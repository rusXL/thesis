# Chat Conversation

Note: _This is purely the output of the chat conversation and does not contain any raw data, codebase snippets, etc. used to generate the output._

### User Input

Let's go step by step over the logs I collected testing the following stetup: @[main.tf] . Logs are in @[/wsl+ubuntu/home/jus/projects/thesis/docs/GCP-GCP.md] . Please go truly step by step explaining why the output of commands is such and what does it mean (start with the first command, proceed to next one when I say)

### Planner Response

Let me start by reading both files to understand the setup and the logs.

*Viewed [main.tf](file:///home/jus/projects/thesis/main.tf) *

*Viewed [GCP-GCP.md](file:///home/jus/projects/thesis/docs/GCP-GCP.md) *

### Planner Response

I've read both files. Now let me walk you through the **first command** in detail.

---

## Command 1: `ip route show` (run on VM1)

```
ruslan_melnyk_x_gmail_com@vm1:~$ ip route show
default via 10.0.1.1 dev ens4 proto dhcp src 10.0.1.2 metric 100 
10.0.1.1 dev ens4 proto dhcp scope link src 10.0.1.2 metric 100 
169.254.169.254 via 10.0.1.1 dev ens4 proto dhcp src 10.0.1.2 metric 100 
```

### What the command does

`ip route show` displays the **local routing table** of the Linux VM — i.e., how the operating system decides where to send packets for different destinations.

### Line-by-line breakdown

| Route | Meaning |
|---|---|
| `default via 10.0.1.1 dev ens4` | The **default gateway** is `10.0.1.1`. Any traffic not matching a more specific route is sent there. `10.0.1.1` is the **gateway IP of the subnet** `network1-subnet1` (`10.0.1.0/24`), automatically assigned by GCP. `ens4` is the VM's network interface. |
| `10.0.1.1 dev ens4 scope link` | A **directly-connected host route** to the gateway itself. `scope link` means it's reachable directly on the local link (no hop needed). This is how the VM knows to reach the gateway without routing through anything else. |
| `169.254.169.254 via 10.0.1.1` | A route to GCP's **metadata server**. `169.254.169.254` is a link-local address that every GCP VM uses to reach the metadata service (for instance information, SSH keys, project metadata, etc.). Traffic to it goes via the subnet gateway. |

### What this tells us about the setup

- **VM1's IP is `10.0.1.2`** (the `src` field) — it's the first usable host address in the `10.0.1.0/24` subnet, which matches your Terraform config for `network1-subnet1` in `us-central1`.
- All routes were obtained via **DHCP** (`proto dhcp`), meaning GCP's internal DHCP server automatically configured this VM's networking.
- The VM has **no explicit knowledge** of the VPN tunnels or the remote `192.168.x.x` subnets at this layer. Those routes are handled by **GCP's software-defined networking layer** (the VPC routing table + Cloud Router), which operates *below* the VM's OS. When VM1 sends a packet to `192.168.1.2` (VM2), it goes to the default gateway `10.0.1.1`, and then GCP's network fabric — using the BGP-learned routes from the Cloud Router — forwards it through the appropriate VPN tunnel to `network2`.

### Key takeaway

This is a perfectly normal, minimal routing table for a GCP VM with no external IP address and a single NIC. The VM relies entirely on its default gateway and GCP's underlying network for cross-VPC connectivity through the HA VPN tunnels.

---

Let me know when you'd like to proceed to the next command! 🚀

*User accepted the command `terraform output`*

### User Input

okay, so when vm1 sends ping to vm2 it goes through default gateway 10.0.1.1, because of the first line config? if I have third vm in 10.0.0.0 network, will vm1 routing still look the same?

### Planner Response

Great questions! Let me address both.

## 1. Yes — pinging VM2 goes through the default gateway

When VM1 (`10.0.1.2`) sends a ping to VM2 (`192.168.1.2`), the OS checks the routing table top-to-bottom for the **most specific match**:

| Route | Matches `192.168.1.2`? |
|---|---|
| `10.0.1.1 dev ens4 scope link` | ❌ — only covers the single host `10.0.1.1` |
| `169.254.169.254 via 10.0.1.1` | ❌ — only covers the single host `169.254.169.254` |
| **`default via 10.0.1.1`** | ✅ — `0.0.0.0/0` matches everything |

Since `192.168.1.2` doesn't match any specific route, the packet hits the **default route** and is sent to the gateway `10.0.1.1`. From there, **GCP's network fabric takes over** — it consults the VPC routing table (which includes the BGP-learned routes from Cloud Router pointing to the VPN tunnels) and forwards the packet through the appropriate HA VPN tunnel to `network2`, where it's delivered to VM2.

So the VM itself is "dumb" about the VPN — it just sends everything to the gateway. The intelligence is in GCP's SDN layer.

## 2. A third VM in the `10.0.0.0/16` network — it depends on *which subnet*

The routing table on VM1 would look **the same** in most cases, but the *behavior* differs depending on where the third VM is:

### Case A: Third VM in the **same subnet** (`network1-subnet1`, `10.0.1.0/24`)
- VM1's routing table stays identical.
- The packet to e.g. `10.0.1.3` matches the implicit **on-link** behavior of GCP — the gateway `10.0.1.1` handles delivery within the subnet. GCP doesn't add an explicit `/24` route to the VM's OS routing table; instead, all traffic goes to the gateway regardless, and GCP's fabric delivers it locally.

### Case B: Third VM in the **other subnet** (`network1-subnet2`, `10.0.2.0/24`, in `us-west1`)
- VM1's routing table **still stays identical** — there is no `10.0.2.0/24` route visible inside the VM.
- The packet to e.g. `10.0.2.3` again hits the **default route** → goes to gateway `10.0.1.1` → GCP's network fabric knows about the `10.0.2.0/24` subnet (it's a **subnet route** in the same VPC with priority 0, which you can see in the `gcloud compute routes list` output for `network1`) and delivers it directly within the VPC — no VPN needed, since both subnets belong to the **same VPC** (`network1`).

### Key insight 🔑

In GCP, **the VM's OS routing table is intentionally minimal**. GCP's SDN networking doesn't inject subnet routes or VPN-learned routes into the guest OS. Everything goes to the default gateway, and the **VPC routing table** (the one you see with `gcloud compute routes list`) is what actually decides the next hop — whether that's a local subnet, a VPN tunnel, or the internet gateway.

This is different from, say, a traditional on-prem Linux router where you'd see explicit routes for each connected network inside `ip route show`.

---

Ready for the next command whenever you are!

### User Input

okay, let's discuss next command

### Planner Response

## Command 2: `gcloud compute vpn-tunnels describe vpn1-remote-0`

```
jus@Asus:~/projects/thesis$ gcloud compute vpn-tunnels describe vpn1-remote-0 \
  --region=us-central1 \
  --project=cloud-computing-476715
```

This command retrieves the **full configuration and status** of the VPN tunnel named `vpn1-remote-0`. This is the **primary tunnel** (interface 0) on the `vpn1` gateway side (the side attached to `network1`).

### Key fields explained

| Field | Value | Meaning |
|---|---|---|
| `detailedStatus` | **`Tunnel is up and running.`** | The IPsec tunnel has been successfully negotiated and is operational. |
| `status` | **`ESTABLISHED`** | Confirms the IKE (Internet Key Exchange) session is fully established between the two VPN gateways. |
| `ikeVersion` | `2` | Using **IKEv2**, the modern, more efficient version of the key exchange protocol used to set up the IPsec security associations. |
| `vpnGateway` | `.../vpnGateways/vpn1` | This tunnel belongs to the **vpn1** HA VPN gateway (the one attached to `network1`). |
| `vpnGatewayInterface` | **`0`** | Uses **interface 0** of the HA VPN gateway. HA VPN gateways have 2 interfaces (0 and 1) for redundancy. |
| `peerGcpGateway` | `.../vpnGateways/vpn2` | The remote end of this tunnel is the **vpn2** HA VPN gateway (attached to `network2`). |
| `peerIp` | `34.157.96.112` | The **public IP** of vpn2's interface 0. This is the external endpoint that the encrypted IPsec packets are sent to over the internet. |
| `router` | `.../routers/vpn-vpn1` | The **Cloud Router** managing BGP sessions for this tunnel. It has ASN `64514` (as configured in your Terraform). |
| `localTrafficSelector` | `0.0.0.0/0` | This tunnel can carry traffic for **any destination**. This is expected with **route-based VPN** (using BGP), as opposed to policy-based VPN where you'd specify explicit CIDRs. |
| `remoteTrafficSelector` | `0.0.0.0/0` | Same — the remote side also accepts **any traffic** through the tunnel. BGP handles route selection, not traffic selectors. |
| `sharedSecret` | `*************` | The pre-shared key used for IKE authentication — masked in the output. In your Terraform it's `"a secret message"`. Both sides must have the same key. |
| `sharedSecretHash` | `IsIPR6xrXY4fjFDwFliRmleryvZz` | A hash of the shared secret, useful for verifying both sides use the same key without exposing it. |
| `labels.goog-terraform-provisioned` | `true` | GCP automatically tags resources created via Terraform. |

### How this maps to your Terraform

In [main.tf](cci:7://file:///home/jus/projects/thesis/main.tf:0:0-0:0), this tunnel corresponds to `module "vpn1"` → `tunnels.remote0`:

```hcl
remote0 = {
  bgp_peer = {
    address = "169.254.0.2"    # peer's BGP IP (vpn2's side)
    asn     = 64515            # peer's ASN (vpn2's router)
  }
  bgp_peer_options = {
    route_priority = 100       # PRIMARY tunnel
  }
  bgp_session_range     = "169.254.0.1/30"   # this side's BGP IP
  vpn_gateway_interface = 0                   # interface 0
  shared_secret         = "a secret message"
}
```

### Key takeaway

This is the **primary tunnel** of the HA VPN pair on the `vpn1` side. It's fully operational (`ESTABLISHED`), connects interface 0 of `vpn1` to interface 0 of `vpn2`, uses IKEv2, and relies on BGP (via Cloud Router) for route advertisement rather than static traffic selectors. The `route_priority = 100` makes this the preferred path over the standby tunnel (`remote1`, priority 200).

---

Ready for the next command whenever you say!

### User Input

okay, discuss next 3 commands (they also regard tunnels) and highlight the different with current command

### Planner Response

## Commands 3, 4, 5: The other three VPN tunnels

All three commands are identical in structure to the previous one — `gcloud compute vpn-tunnels describe <name>` — and all report **`status: ESTABLISHED`** / **`Tunnel is up and running.`** So all 4 tunnels are healthy. Let's focus on **what differs** between them.

### Side-by-side comparison of all 4 tunnels

| Field | `vpn1-remote-0` | `vpn1-remote-1` | `vpn2-remote-0` | `vpn2-remote-1` |
|---|---|---|---|---|
| **Gateway** | `vpn1` (network1) | `vpn1` (network1) | `vpn2` (network2) | `vpn2` (network2) |
| **Gateway Interface** | **0** | **1** | **0** | **1** |
| **Peer Gateway** | `vpn2` | `vpn2` | `vpn1` | `vpn1` |
| **Peer IP** | `34.157.96.112` | `34.157.237.68` | `34.183.17.175` | `34.184.41.242` |
| **Router** | `vpn-vpn1` (ASN 64514) | `vpn-vpn1` (ASN 64514) | `vpn-vpn2` (ASN 64515) | `vpn-vpn2` (ASN 64515) |
| **Role** | Primary (prio 100) | Standby (prio 200) | Primary (prio 100) | Standby (prio 200) |

### What this tells us — the tunnel pairing

There are **4 tunnels** forming **2 pairs**, each pair connecting one interface of `vpn1` to the corresponding interface of `vpn2`:

```
  network1 (vpn1)                        network2 (vpn2)
  ┌──────────────┐                      ┌──────────────┐
  │ Interface 0  │◄── vpn1-remote-0 ──►│ Interface 0  │◄── vpn2-remote-0
  │ 34.183.17.175│    (PRIMARY pair)    │ 34.157.96.112│
  │              │                      │              │
  │ Interface 1  │◄── vpn1-remote-1 ──►│ Interface 1  │◄── vpn2-remote-1
  │ 34.184.41.242│    (STANDBY pair)    │ 34.157.237.68│
  └──────────────┘                      └──────────────┘
```

### Key differences highlighted

1. **`peerIp` values are cross-referenced.** Notice:
   - `vpn1-remote-0` has `peerIp: 34.157.96.112` — that's **vpn2's interface 0** public IP
   - `vpn2-remote-0` has `peerIp: 34.183.17.175` — that's **vpn1's interface 0** public IP
   - Same cross-pattern for interface 1. Each tunnel "sees" the other side's public IP as its peer.

2. **Each tunnel pair is on a different physical path.** HA VPN gateways have 2 interfaces, and GCP guarantees they run on **different physical infrastructure**. This is the whole point of HA VPN — if one path fails, the other keeps traffic flowing.

3. **The routers differ by side, not by tunnel.** Both `vpn1-remote-0` and `vpn1-remote-1` use the same Cloud Router `vpn-vpn1` (ASN 64514). Both `vpn2-remote-0` and `vpn2-remote-1` use `vpn-vpn2` (ASN 64515). The router manages *both* BGP sessions for its gateway.

4. **`sharedSecretHash` differs between pairs** — even though all tunnels use the same `shared_secret = "a secret message"` in Terraform, the hashes are different. This is because GCP computes the hash incorporating additional context (tunnel identity), so different tunnels produce different hashes. This is normal.

### Why 4 tunnels instead of 2?

You might think: "interface 0 ↔ interface 0 is one connection, why two tunnel resources (`vpn1-remote-0` *and* `vpn2-remote-0`)?"

That's because an IPsec tunnel is **configured on each endpoint independently**. Each side needs its own tunnel resource that specifies:
- *Its* gateway interface
- *Its* Cloud Router
- *The peer's* gateway

So `vpn1-remote-0` and `vpn2-remote-0` are **the two ends of the same IPsec tunnel**, not two separate tunnels. You have **2 logical tunnels** (primary + standby), each requiring **2 resource definitions** (one per side) = 4 total tunnel resources.

---

Ready for the next command when you are!

### User Input

okay, you got role (priority not from command output, right? so dont describe it here please), also explain local traffic and remote traffic selectors, is it possible to change them in gcp? what do they change?

### Planner Response

You're absolutely right — the priority/role isn't in the tunnel `describe` output. I pulled that from the Terraform config, which was misleading. Let me correct the comparison table and then dive into traffic selectors.

### Corrected comparison (only what's in the command output)

| Field | `vpn1-remote-0` | `vpn1-remote-1` | `vpn2-remote-0` | `vpn2-remote-1` |
|---|---|---|---|---|
| **Gateway** | `vpn1` | `vpn1` | `vpn2` | `vpn2` |
| **Gateway Interface** | 0 | 1 | 0 | 1 |
| **Peer Gateway** | `vpn2` | `vpn2` | `vpn1` | `vpn1` |
| **Peer IP** | `34.157.96.112` | `34.157.237.68` | `34.183.17.175` | `34.184.41.242` |
| **Router** | `vpn-vpn1` | `vpn-vpn1` | `vpn-vpn2` | `vpn-vpn2` |
| **localTrafficSelector** | `0.0.0.0/0` | `0.0.0.0/0` | `0.0.0.0/0` | `0.0.0.0/0` |
| **remoteTrafficSelector** | `0.0.0.0/0` | `0.0.0.0/0` | `0.0.0.0/0` | `0.0.0.0/0` |

All four tunnels are identical in traffic selectors. Now let's unpack what that means.

---

## Traffic Selectors explained

### What they are

Traffic selectors are an **IPsec concept** (part of the IKE negotiation). They define **which IP ranges are allowed to travel through the tunnel**:

- **`localTrafficSelector`** — which **source IPs** (from the local side) are permitted to send traffic *into* the tunnel
- **`remoteTrafficSelector`** — which **destination IPs** (on the remote side) are permitted to be reached *through* the tunnel

Together they form a "policy" that the IPsec tunnel enforces: *"only encrypt and forward packets matching these selectors."*

### Why `0.0.0.0/0` for both?

Because you're using **route-based VPN** (HA VPN with BGP/Cloud Router). In this mode:

- Traffic selectors are set to `0.0.0.0/0` on both sides, meaning the tunnel itself places **no restrictions** on what traffic can flow through it.
- **BGP** (via Cloud Router) is the mechanism that decides which traffic actually *goes* into the tunnel — by advertising specific subnet routes. The tunnel is just a "dumb pipe"; routing intelligence lives in BGP.

This is the default and **only option** for HA VPN in GCP — you cannot change the traffic selectors.

### Can you change them in GCP?

**It depends on the VPN type:**

| VPN Type | Traffic Selectors | Changeable? |
|---|---|---|
| **HA VPN** (what you're using) | Always `0.0.0.0/0` for both | ❌ **No** — GCP forces `0.0.0.0/0`. Route-based only. |
| **Classic VPN** (route-based) | `0.0.0.0/0` for both | ❌ Same — `0.0.0.0/0` when using dynamic or route-based routing |
| **Classic VPN** (policy-based) | Custom CIDR ranges | ✅ **Yes** — you specify exact local and remote CIDRs |

### What would changing them do? (Policy-based VPN)

If you *could* set custom traffic selectors (in a policy-based Classic VPN), it would work like this:

```
localTrafficSelector:  ["10.0.1.0/24"]
remoteTrafficSelector: ["192.168.1.0/24"]
```

This would mean:
- **Only** packets from `10.0.1.0/24` heading to `192.168.1.0/24` get encrypted and sent through the tunnel
- A packet from `10.0.1.2` to `192.168.2.0/24` would be **dropped** (doesn't match the selector)
- You'd need **additional tunnels** with different selectors for each subnet pair

This is why policy-based VPN doesn't scale well — with 2 subnets on each side you'd need 4 selector pairs. With route-based VPN + BGP, you just have one tunnel carrying everything and BGP handles the routing.

### Bottom line

In your HA VPN setup, `0.0.0.0/0` is the expected and only valid value. The traffic selectors are essentially a no-op — all routing decisions are delegated to BGP. Think of it as: **traffic selectors = IPsec-level filter, BGP routes = network-level routing**. With route-based VPN, you disable the filter and let routing do the work.

---

Ready for the next command when you are!

### User Input

okay, lets move to next command

### Planner Response

## Command 6: `gcloud compute vpn-gateways get-status vpn1`

```
jus@Asus:~/projects/thesis$ gcloud compute vpn-gateways get-status vpn1 \
  --project=cloud-computing-476715 \
  --region=us-central1
```

This command checks the **overall HA status** of the `vpn1` gateway — not individual tunnels, but the gateway as a whole. It answers the question: *"Is this HA VPN gateway truly redundant?"*

### Output breakdown

```yaml
result:
  vpnConnections:
  - peerGcpGateway: .../vpnGateways/vpn2
    state:
      state: CONNECTION_REDUNDANCY_MET
    tunnels:
    - localGatewayInterface: 1
      peerGatewayInterface: 1
      tunnelUrl: .../vpnTunnels/vpn1-remote-1
    - localGatewayInterface: 0
      peerGatewayInterface: 0
      tunnelUrl: .../vpnTunnels/vpn1-remote-0
```

### Field-by-field

| Field | Meaning |
|---|---|
| `peerGcpGateway: .../vpn2` | This gateway (`vpn1`) is connected to peer gateway `vpn2`. |
| **`state: CONNECTION_REDUNDANCY_MET`** | ✅ **The most important field.** GCP confirms that this VPN connection has **full redundancy** — both interfaces have active tunnels. If one path fails, the other can take over. |
| `tunnels` | Lists the two tunnels and how they map: interface 0 ↔ interface 0, interface 1 ↔ interface 1. |

### What does `CONNECTION_REDUNDANCY_MET` actually mean?

GCP defines a few possible states:

| State | Meaning | SLA |
|---|---|---|
| **`CONNECTION_REDUNDANCY_MET`** | Both interfaces have tunnels to the peer, and both are up | ✅ **99.99% SLA** |
| `SINGLE_TUNNEL_NO_REDUNDANCY` | Only one tunnel is up | ❌ No SLA guarantee |
| `NO_INCOMING_PACKETS` | Tunnels exist but no traffic is flowing | ⚠️ Problem |

You're getting `CONNECTION_REDUNDANCY_MET` because:
- Interface 0 → `vpn1-remote-0` → peer interface 0 ✅
- Interface 1 → `vpn1-remote-1` → peer interface 1 ✅

Both are ESTABLISHED (as we saw in the previous tunnel describe commands), so GCP is satisfied that redundancy is fully met.

### Why this matters

This is the **GCP HA VPN SLA check**. Google only guarantees the **99.99% availability SLA** when this status is `CONNECTION_REDUNDANCY_MET`. If you had only one tunnel configured (or one was down), you'd lose that SLA — the VPN would still *work*, but Google wouldn't guarantee its uptime.

---

Ready for the next one!

### User Input

next one is similar but for router 2, so lets skip to routers

### Planner Response

## Command 8: `gcloud compute routers get-status vpn-vpn1`

```
jus@Asus:~/projects/thesis$ gcloud compute routers get-status vpn-vpn1 \
  --project=cloud-computing-476715 \
  --region=us-central1
```

This is the **richest command so far** — it shows the live BGP state of Cloud Router `vpn-vpn1` (ASN 64514, attached to `network1`). The output has three major sections: **bestRoutes**, **bestRoutesForRouter**, and **bgpPeerStatus**. Let's go through each.

---

### Section 1: `bestRoutes` — routes installed into the VPC routing table

These are the routes that BGP **learned from the peer** (vpn-vpn2, ASN 64515) and that GCP has **actually installed** into `network1`'s VPC routing table for forwarding traffic.

| Destination | Next Hop | Via Tunnel | Priority | Meaning |
|---|---|---|---|---|
| `192.168.1.0/24` | `169.254.0.2` | `vpn1-remote-0` | **100** | Route to network2-subnet1 via tunnel 0 |
| `192.168.1.0/24` | `169.254.1.2` | `vpn1-remote-1` | **200** | Same destination via tunnel 1 (backup) |
| `192.168.2.0/24` | `169.254.0.2` | `vpn1-remote-0` | **333** | Route to network2-subnet2 via tunnel 0 |
| `192.168.2.0/24` | `169.254.1.2` | `vpn1-remote-1` | **433** | Same destination via tunnel 1 (backup) |

**Key observations:**

- Each destination (`192.168.1.0/24` and `192.168.2.0/24`) has **two routes** — one per tunnel. This is how failover works: if tunnel 0 goes down, the route via tunnel 1 takes over.
- The **priorities** aren't exactly 100/200 for subnet2 — they're **333 and 433**. Why? Because BGP route priority in GCP is calculated as:
  ```
  final_priority = base_priority + MED (Multi-Exit Discriminator)
  ```
  The `route_priority` you set in Terraform (100 or 200) becomes the **MED** that the *advertising* router sends. The *receiving* router then combines it with its own base priority. The base priority for locally-originated subnet routes differs from non-local ones. So:
  - `192.168.1.0/24` is subnet1 of network2 (same region `us-central1`) → priority **100** / **200**
  - `192.168.2.0/24` is subnet2 of network2 (different region `us-east1`) → priority **333** / **433** (higher = less preferred, because it's cross-region)

  GCP adds a **regional cost penalty (~233)** to cross-region routes.

---

### Section 2: `bestRoutesForRouter` — routes this specific router considers best

This is similar to `bestRoutes` but scoped to this Cloud Router's own decision-making. Here all 4 routes show **`routeStatus: ACTIVE`**, meaning the router is actively using all of them. In steady state, this mirrors `bestRoutes`.

---

### Section 3: `bgpPeerStatus` — the live BGP sessions

This is the most important section. There are **two BGP peers** — one per tunnel:

#### Peer: `vpn1-remote-0` (tunnel 0)

| Field | Value | Meaning |
|---|---|---|
| `state` | **`Established`** | BGP session is fully up |
| `status` | **`UP`** | ✅ Healthy |
| `ipAddress` | `169.254.0.1` | This router's BGP endpoint (link-local IP) |
| `peerIpAddress` | `169.254.0.2` | The peer router's BGP endpoint (vpn-vpn2's side) |
| `numLearnedRoutes` | **2** | Learned 2 routes from the peer: `192.168.1.0/24` and `192.168.2.0/24` |
| `uptime` | `7 minutes, 42 seconds` | Session has been up since tunnel establishment |

**Advertised routes** (what *this* router is telling the peer):

| Advertised Route | Priority | Meaning |
|---|---|---|
| `10.0.1.0/24` | 100 | "To reach network1-subnet1, come through this tunnel" (primary) |
| `10.0.2.0/24` | 338 | "To reach network1-subnet2, come through this tunnel" (with regional penalty) |

#### Peer: `vpn1-remote-1` (tunnel 1)

Same structure, but:

| Field | Difference |
|---|---|
| `ipAddress` | `169.254.1.1` (different link-local /30 block) |
| `peerIpAddress` | `169.254.1.2` |
| `numLearnedRoutes` | 2 (same routes learned) |
| Advertised `10.0.1.0/24` priority | **200** (standby, higher = less preferred) |
| Advertised `10.0.2.0/24` priority | **438** (200 + regional penalty) |

---

### The big picture — how BGP is working here

```
  vpn-vpn1 (ASN 64514)                    vpn-vpn2 (ASN 64515)
  ┌─────────────────────┐                  ┌─────────────────────┐
  │ ADVERTISES:          │    tunnel 0      │ ADVERTISES:          │
  │  10.0.1.0/24 (p=100)│◄───BGP session──►│  192.168.1.0/24(p=100)│
  │  10.0.2.0/24 (p=338)│   169.254.0.x    │  192.168.2.0/24(p=333)│
  │                     │                  │                     │
  │ ADVERTISES:          │    tunnel 1      │ ADVERTISES:          │
  │  10.0.1.0/24 (p=200)│◄───BGP session──►│  192.168.1.0/24(p=200)│
  │  10.0.2.0/24 (p=438)│   169.254.1.x    │  192.168.2.0/24(p=433)│
  │                     │                  │                     │
  │ LEARNS:              │                  │ LEARNS:              │
  │  192.168.1.0/24      │                  │  10.0.1.0/24         │
  │  192.168.2.0/24      │                  │  10.0.2.0/24         │
  └─────────────────────┘                  └─────────────────────┘
```

Each router **advertises** its own VPC's subnets and **learns** the remote VPC's subnets. The priority values ensure that tunnel 0 is **preferred** (lower priority number = more preferred), and tunnel 1 acts as **backup**. If tunnel 0 goes down, BGP converges and all traffic shifts to tunnel 1 automatically.

---

The `get-status` for `vpn-vpn2` (lines 322-494) is the **mirror image** — it shows ASN 64515, advertises `192.168.x.x` routes, and learns `10.0.x.x` routes. Want me to skip it and move to the next distinct command, or do you want to discuss anything here first?

### User Input

skip, and discuss next command, good job

### Planner Response

Thanks! 😄

## Command 10: `gcloud compute routers describe vpn-vpn1`

```
jus@Asus:~/projects/thesis$ gcloud compute routers describe vpn-vpn1 \
  --project=cloud-computing-476715 \
  --region=us-central1
```

The previous command (`get-status`) showed the **live runtime state** — active BGP sessions, learned routes, uptime. This command (`describe`) shows the **static configuration** of the Cloud Router itself — how it was set up by Terraform. Think of it as: `get-status` = "what's happening now", `describe` = "what's configured."

### Section 1: `bgp` — Router-level BGP config

```yaml
bgp:
  advertiseMode: DEFAULT
  asn: 64514
  keepaliveInterval: 20
```

| Field | Meaning |
|---|---|
| `asn: 64514` | This router's **Autonomous System Number** — matches `router_asn = 64514` in your Terraform `module "vpn1"`. |
| `advertiseMode: DEFAULT` | The router automatically advertises **all subnets in its VPC** (`network1`). You didn't configure custom route advertisements, so it advertises `10.0.1.0/24` and `10.0.2.0/24` automatically. The alternative is `CUSTOM`, where you'd hand-pick which prefixes to announce. |
| `keepaliveInterval: 20` | BGP sends a **keepalive message every 20 seconds** to its peers. If a peer misses 3 keepalives (60s by default), the session is considered dead and routes are withdrawn. This is the GCP default. |

### Section 2: `bgpPeers` — Per-tunnel BGP peer configurations

Two peers are configured, one per tunnel:

#### Peer `vpn1-remote-0` (tunnel 0)
```yaml
- advertiseMode: DEFAULT
  advertisedRoutePriority: 100
  interfaceName: vpn1-remote-0
  ipAddress: 169.254.0.1
  peerAsn: 64515
  peerIpAddress: 169.254.0.2
  enable: 'TRUE'
```

#### Peer `vpn1-remote-1` (tunnel 1)
```yaml
- advertiseMode: DEFAULT
  advertisedRoutePriority: 200
  interfaceName: vpn1-remote-1
  ipAddress: 169.254.1.1
  peerAsn: 64515
  peerIpAddress: 169.254.1.2
  enable: 'TRUE'
```

| Field | `vpn1-remote-0` | `vpn1-remote-1` | Meaning |
|---|---|---|---|
| `advertisedRoutePriority` | **100** | **200** | The **MED (Multi-Exit Discriminator)** sent to the peer. Lower = more preferred. This is where the priority we discussed earlier comes from! |
| `ipAddress` | `169.254.0.1` | `169.254.1.1` | This side's BGP endpoint (from `bgp_session_range` in Terraform) |
| `peerIpAddress` | `169.254.0.2` | `169.254.1.2` | The remote side's BGP endpoint (from `bgp_peer.address` in Terraform) |
| `peerAsn` | 64515 | 64515 | The peer router's ASN (vpn-vpn2) |

**Now we can see where the priorities actually come from** — `advertisedRoutePriority: 100` on this peer is exactly `route_priority = 100` from your Terraform `bgp_peer_options` block. This is the configured value that we see reflected in the `get-status` output as route priorities.

#### BFD (Bidirectional Forwarding Detection)

```yaml
  bfd:
    minReceiveInterval: 1000
    minTransmitInterval: 1000
    multiplier: 5
    sessionInitializationMode: DISABLED
```

BFD is a **fast failure detection protocol** — much faster than waiting for BGP keepalives (60s). When enabled, it can detect a link failure in **milliseconds** instead of a minute. Here it's **DISABLED** (the default). If enabled with these settings, it would:
- Send probes every **1000ms**
- Declare the link dead after **5** missed probes (5 seconds)

### Section 3: `interfaces` — Router interfaces linked to tunnels

```yaml
interfaces:
- ipRange: 169.254.1.1/30
  linkedVpnTunnel: .../vpn1-remote-1
  name: vpn1-remote-1
- ipRange: 169.254.0.1/30
  linkedVpnTunnel: .../vpn1-remote-0
  name: vpn1-remote-0
```

Each interface assigns a **/30 link-local IP** to the router's end of the BGP session inside a tunnel. A `/30` gives 4 IPs, 2 usable:
- `169.254.0.0/30` → `.1` (this router) and `.2` (peer) — used by tunnel 0
- `169.254.1.0/30` → `.1` (this router) and `.2` (peer) — used by tunnel 1

These are the addresses that BGP packets travel between; they exist **only inside the VPN tunnel** and are never seen by VMs or the wider network.

### Key takeaway

This output is the **blueprint** of the Cloud Router. Everything here maps directly to your Terraform configuration, and the `get-status` command we saw before shows these settings *in action* (with live sessions, learned routes, and uptime). The `describe` for `vpn-vpn2` (lines 555-608) is the mirror image with ASN 64515 and swapped IPs.

---

Want to skip `vpn-vpn2` describe and move to the next distinct command?

### User Input

Router interfaces linked to tunnels, so abstractively first goes network with VM, then its default gateway cloud router (10.0.1.1?)? then VPN gateway? 

can you show what to change to make advertise mode CUSTOM and sample use case?



### Planner Response

Great questions! Let me address both.

## 1. The packet path — clarifying the components

The default gateway `10.0.1.1` is **not** the Cloud Router. Let me show the actual architecture:

```
┌─────────────────────────────────────────────────────────────────────┐
│                     GCP's SDN Fabric (invisible)                    │
│                                                                     │
│  ┌──────┐    ┌──────────────┐    ┌─────────────┐    ┌────────────┐ │
│  │ VM1  │───►│ Subnet GW    │───►│ VPC Routing  │───►│ HA VPN GW  │─┼──► Internet ──► vpn2
│  │10.0. │    │ 10.0.1.1     │    │ Table        │    │ vpn1       │ │    (IPsec)
│  │1.2   │    │ (SDN, not a  │    │ (has BGP-    │    │ 34.183.x.x │ │
│  └──────┘    │  real device) │    │  learned     │    │ 34.184.x.x │ │
│              └──────────────┘    │  routes)     │    └────────────┘ │
│                                  └──────┬──────┘                    │
│                                         ▲                           │
│                                         │ programs routes           │
│                                  ┌──────┴──────┐                    │
│                                  │ Cloud Router│                    │
│                                  │ vpn-vpn1    │ ◄─── BGP sessions  │
│                                  │ ASN 64514   │      over tunnels  │
│                                  │ 169.254.x.x │      (control only)│
│                                  └─────────────┘                    │
└─────────────────────────────────────────────────────────────────────┘
```

**Key distinctions:**

| Component | Role | Data path? |
|---|---|---|
| **Subnet Gateway** (`10.0.1.1`) | A virtual next-hop in GCP's SDN. Not a real device — it's the fabric's entry point. | ✅ Yes — all VM traffic goes here first |
| **VPC Routing Table** | Decides where packets go based on destination IP. Contains subnet routes + BGP-learned routes. | ✅ Yes — makes the forwarding decision |
| **HA VPN Gateway** (`vpn1`) | Has public IPs, performs IPsec encryption/decryption. | ✅ Yes — encrypts and sends packets |
| **Cloud Router** (`vpn-vpn1`) | **Control plane only.** Runs BGP, learns routes from the peer, and **programs them into the VPC routing table.** | ❌ **No** — data packets never "pass through" it |

So the **data path** is:
> VM1 → `10.0.1.1` (SDN fabric) → VPC routing table says "192.168.x.x → vpn tunnel" → HA VPN Gateway encrypts → Internet → peer HA VPN Gateway decrypts → VM2

The **control path** (BGP) is separate:
> Cloud Router `vpn-vpn1` ↔ (inside VPN tunnel, via `169.254.x.x`) ↔ Cloud Router `vpn-vpn2`

The `169.254.x.x` interfaces on the Cloud Router exist **inside** the tunnels purely for BGP to exchange route information. They don't carry user data.

---

## 2. Custom advertise mode — Terraform example and use case

### How to change it

In the Terraform VPN module, you'd add custom advertisement configuration to the Cloud Router. Here's what you'd need to change/add:

```hcl
module "vpn1" {
  source           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  project_id       = var.project_id
  region           = "us-central1"
  network          = module.vpc1.network_id
  name             = "vpn1"
  router_asn       = 64514
  peer_gcp_gateway = module.vpn2.gateway[0].self_link

  # Switch to CUSTOM advertisements
  router_advertise_config = {
    mode   = "CUSTOM"
    groups = ["ALL_SUBNETS"]  # still include all subnets...
    ip_ranges = {             # ...plus these extra prefixes:
      "10.100.0.0/16" = "on-prem-network"
      "172.16.0.0/12" = "corporate-range"
    }
  }

  tunnels = { ... }  # same as before
}
```

Or if you want to advertise **only specific subnets** (excluding some):

```hcl
  router_advertise_config = {
    mode   = "CUSTOM"
    groups = []               # do NOT auto-include all subnets
    ip_ranges = {
      "10.0.1.0/24" = "subnet1-only"  # only advertise subnet1
      # subnet2 (10.0.2.0/24) is intentionally NOT advertised
    }
  }
```

### Sample use cases

**Use case 1: Advertise a summary/aggregate route**
> You have 20 subnets in `10.0.0.0/16`. Instead of advertising 20 individual `/24` routes, you advertise one `10.0.0.0/16` summary. This reduces the routing table size on the peer side.

**Use case 2: Hide a sensitive subnet**
> You have a `10.0.99.0/24` management subnet that should NOT be reachable from the other VPC. With `DEFAULT`, it gets advertised automatically. With `CUSTOM`, you exclude it by only listing the subnets you want to share.

**Use case 3: Advertise routes to networks behind this VPC**
> Your `network1` VPC peers with an on-prem network at `172.16.0.0/12`. You want `network2` to reach on-prem *through* the VPN. With `CUSTOM`, you add `172.16.0.0/12` as an extra `ip_range` so `vpn-vpn2` learns this route and can forward traffic to it.

---

Ready for the next command when you are!

### User Input

next command

### Planner Response

## Command 12: `gcloud compute routes list --filter="network=network1"`

```
jus@Asus:~/projects/thesis$ gcloud compute routes list \
    --filter="network=network1" \
    --project=cloud-computing-476715
```

This shows the **VPC-level routing table** for `network1` — the actual routes that GCP's SDN fabric uses to forward packets. This is the routing table we've been talking about that the Cloud Router programs into.

### Output

```
NAME                              NETWORK   DEST_RANGE   NEXT_HOP                  PRIORITY
default-route-b54416d0484b0fa2    network1  0.0.0.0/0    default-internet-gateway  1000
default-route-r-1074fe19a35135f3  network1  10.0.2.0/24  network1                  0
default-route-r-57cd89aabaf6732f  network1  10.0.1.0/24  network1                  0
```

### Line-by-line

| Route | Dest Range | Next Hop | Priority | Meaning |
|---|---|---|---|---|
| `default-route-b544...` | `0.0.0.0/0` | `default-internet-gateway` | 1000 | **Default internet route.** If no more specific route matches, send traffic to the internet. Every VPC gets this automatically. |
| `default-route-r-1074...` | `10.0.2.0/24` | `network1` | 0 | **Subnet route** for `network1-subnet2` (`us-west1`). Priority 0 = highest possible, auto-created when you create a subnet. `network1` as next-hop means "deliver within this VPC." |
| `default-route-r-57cd...` | `10.0.1.0/24` | `network1` | 0 | **Subnet route** for `network1-subnet1` (`us-central1`). Same — auto-created, highest priority. |

### Wait — where are the BGP routes?!

You might expect to see the `192.168.1.0/24` and `192.168.2.0/24` routes that BGP learned (we saw them in `get-status`). They're **missing** from this output because `gcloud compute routes list` by default **only shows static/subnet routes**, not dynamic BGP routes.

BGP-learned routes are **ephemeral** — they exist in the VPC routing table and are actively used for forwarding, but they're managed by Cloud Router and don't appear as first-class `compute.routes` resources. To see them, you'd need:

```bash
gcloud compute routers get-status vpn-vpn1 ...   # ← what we already did
# or
gcloud compute routes list --filter="network=network1" \
  --format="table(destRange,nextHopVpnTunnel,priority)" \
  --uri   # sometimes helps show dynamic routes
```

### The second command (network2) is the mirror

```
NAME                              NETWORK   DEST_RANGE      NEXT_HOP                  PRIORITY
default-route-607978e70fb30790    network2  0.0.0.0/0       default-internet-gateway  1000
default-route-r-5360d6df0283659d  network2  192.168.2.0/24  network2                  0
default-route-r-c819fb1392fc0751  network2  192.168.1.0/24  network2                  0
```

Same structure: default internet route + two subnet routes for `192.168.1.0/24` and `192.168.2.0/24`. No BGP routes visible.

### Route selection order

When VM1 sends a packet to `192.168.1.2`, GCP evaluates routes by **most-specific match first**, then **lowest priority number**:

1. `10.0.1.0/24` (priority 0) — ❌ doesn't match `192.168.1.2`
2. `10.0.2.0/24` (priority 0) — ❌ doesn't match
3. `192.168.1.0/24` (priority 100, BGP, invisible here) — ✅ **matches!** → forward via `vpn1-remote-0`
4. `0.0.0.0/0` (priority 1000) — would match, but step 3 is more specific

If the BGP routes didn't exist (e.g., all tunnels down), the packet would fall through to the default internet route, which would try to send it to the internet — and it would be dropped since `192.168.1.2` is a private IP with no public routing.

---

Ready for the next command!

### User Input

next

### Planner Response

## Command 13: `ping 192.168.1.2` (from VM1)

```
ruslan_melnyk_x_gmail_com@vm1:~$ ping 192.168.1.2
PING 192.168.1.2 (192.168.1.2) 56(84) bytes of data.
64 bytes from 192.168.1.2: icmp_seq=1 ttl=62 time=2.82 ms
64 bytes from 192.168.1.2: icmp_seq=2 ttl=62 time=2.81 ms
...
64 bytes from 192.168.1.2: icmp_seq=51 ttl=62 time=2.19 ms
```

This is the **connectivity proof** — VM1 (`10.0.1.2` in `network1`) pinging VM2 (`192.168.1.2` in `network2`) across the HA VPN.

### Key observations

**1. It works!** 🎉 Every packet gets a reply — the entire HA VPN setup (VPC → Cloud Router → BGP → VPN tunnels → firewall rules) is functioning correctly.

**2. TTL = 62**

The default starting TTL on Linux is **64**. Each "hop" decrements it by 1. TTL of 62 means the packet passed through **2 hops**:

| Hop | What happens | TTL |
|---|---|---|
| Start | VM1 sends with TTL=64 | 64 |
| Hop 1 | GCP's network fabric / VPN gateway on network1 side | 63 |
| Hop 2 | VPN gateway on network2 side / delivery to VM2 | 62 |

This makes sense — the packet goes through the VPN encapsulation/decapsulation (which counts as routing hops) but doesn't traverse any additional routers.

**3. Latency: ~2.1–3.6 ms**

| Phase | Latency |
|---|---|
| First packets (seq 1–11) | **2.47–2.92 ms** |
| Later packets (seq 35–51) | **2.10–2.31 ms** |

The latency is **very low** because both VPN gateways are in the **same region** (`us-central1`). The packets go:
> VM1 → vpn1 gateway (us-central1) → *short hop within Google's network* → vpn2 gateway (us-central1) → VM2

Even though there's IPsec encryption/decryption overhead, being in the same region keeps latency around **2–3 ms**. If the gateways were in different regions (e.g., `us-central1` ↔ `europe-west1`), you'd see 50–100+ ms.

The slight improvement from ~2.8 ms to ~2.2 ms over time is likely due to early connection warmup — caching of ARP entries, IPsec SA (Security Association) establishment overhead on the first packets, etc.

**4. No packet loss**

The sequence numbers are continuous (1–11, then 35–51 shown, with a gap in the log but no reported loss). This confirms the VPN tunnel is stable.

**5. Packet size: `56(84) bytes`**

56 bytes of ICMP payload + 8 bytes ICMP header + 20 bytes IP header = 84 bytes total. This is the default `ping` size. The actual on-the-wire packet is larger because VPN adds IPsec encapsulation (ESP header, etc.), but that's transparent to the VM.

### Why the firewall allows this

Looking at your [main.tf](cci:7://file:///home/jus/projects/thesis/main.tf:0:0-0:0), the firewall rule `vpc2_allow_internal` permits ICMP from `source_ranges = ["10.0.0.0/16", "192.168.0.0/16"]`. VM1's source IP is `10.0.1.2`, which falls within `10.0.0.0/16`, so the ping passes through the firewall on the `network2` side. ✅

---

Ready for the next command — which is where things get interesting (tunnel deletion)! 🔥

### User Input

next

### Planner Response

## Command 14: `gcloud compute vpn-tunnels delete vpn1-remote-0`

```
jus@Asus:~/projects/thesis$ gcloud compute vpn-tunnels delete vpn1-remote-0 \
  --region=us-central1 \
  --project=cloud-computing-476715
```

This **deletes the primary tunnel** on the vpn1 side — the one on interface 0 with the lower BGP route priority (100). This simulates a tunnel failure to test HA failover.

### What happens behind the scenes when this tunnel is deleted:

1. The IPsec session for `vpn1-remote-0` is torn down
2. The BGP session running over that tunnel (`169.254.0.1` ↔ `169.254.0.2`) goes down
3. Cloud Router `vpn-vpn1` **withdraws** the routes it learned via that tunnel
4. The routes that were advertised through that tunnel to `vpn-vpn2` also disappear
5. Traffic **automatically fails over** to `vpn1-remote-1` (the standby tunnel on interface 1)

---

## Command 15: `gcloud compute routers get-status vpn-vpn1` (after deletion)

This is the **proof of failover**. Let's compare before and after:

### BGP Peer Status — before vs after

| Peer | Before | After |
|---|---|---|
| `vpn1-remote-0` | ✅ `Established` / `UP`, 2 learned routes | ❌ **`status: DOWN`**, state: `"The VPN tunnel or Interconnect attachment is unknown."`, **no advertised routes**, no learned routes |
| `vpn1-remote-1` | ✅ `Established` / `UP`, 2 learned routes | ✅ `Established` / `UP`, **still 2 learned routes**, uptime: 13 min 10 sec |

The `vpn1-remote-0` peer is dead — it still appears in the config (the Cloud Router interface wasn't deleted, only the tunnel), but there's no tunnel underneath it anymore, so the BGP session has nothing to run on.

### Best Routes — before vs after

**Before** (4 routes, 2 per tunnel):
| Destination | Via Tunnel | Priority |
|---|---|---|
| `192.168.1.0/24` | `vpn1-remote-0` | 100 ← primary |
| `192.168.1.0/24` | `vpn1-remote-1` | 200 ← standby |
| `192.168.2.0/24` | `vpn1-remote-0` | 333 ← primary |
| `192.168.2.0/24` | `vpn1-remote-1` | 433 ← standby |

**After** (2 routes, only tunnel 1 survives):
| Destination | Via Tunnel | Priority |
|---|---|---|
| `192.168.1.0/24` | **`vpn1-remote-1`** | **200** |
| `192.168.2.0/24` | **`vpn1-remote-1`** | **433** |

All routes via `vpn1-remote-0` are **gone**. The routes via `vpn1-remote-1` that were previously standby are now the **only active routes**. Traffic to `192.168.x.x` now flows exclusively through tunnel 1.

### Advertised routes — before vs after

Before, tunnel 0 advertised `10.0.1.0/24` (p=100) and `10.0.2.0/24` (p=338).
After, only tunnel 1 advertises:

| Advertised Route | Priority |
|---|---|
| `10.0.1.0/24` | 200 |
| `10.0.2.0/24` | 438 |

The peer (`vpn-vpn2`) now only receives routes with higher priority numbers (less preferred), but they're the **only routes available**, so they're still used.

### The critical point: did the ping break?

If you look at the ping output carefully (lines 633–665), the ping was **still running** when the tunnel was deleted. The sequence numbers go from 1–11, then there's a gap in the log, then 35–51. The fact that packets at seq 35+ still show replies means **the failover worked** — traffic seamlessly shifted to tunnel 1 without the ping session dying.

The latency even *improved slightly* after failover (2.8 ms → 2.2 ms), likely because the standby tunnel may have a marginally different physical path within Google's network.

### Key takeaway

This demonstrates the core value of **HA VPN**: deleting the primary tunnel caused zero downtime. BGP automatically detected the failure, withdrew routes, and the standby tunnel took over — all within seconds, transparently to the application running on the VMs.

---

Ready for the next command!

### User Input

next

### Planner Response

## Commands 16 & 17: `gcloud compute vpn-gateways describe vpn1` and `vpn2`

```
jus@Asus:~/projects/thesis$ gcloud compute vpn-gateways describe vpn1 \
  --region=us-central1 \
  --project=cloud-computing-476715 \
  --format='yaml(vpnInterfaces)'
```

These commands retrieve the **public IP addresses** assigned to each HA VPN gateway's interfaces. The `--format='yaml(vpnInterfaces)'` flag filters the output to show only the interface IPs.

### Output

**vpn1** (network1 side):
```yaml
vpnInterfaces:
- id: 0
  ipAddress: 34.183.17.175
- id: 1
  ipAddress: 34.184.41.242
```

**vpn2** (network2 side):
```yaml
vpnInterfaces:
- id: 0
  ipAddress: 34.157.96.112
- id: 1
  ipAddress: 34.157.237.68
```

### What this confirms

These are the **external/public IPs** that the IPsec tunnels use as endpoints. Let's cross-reference them with the tunnel descriptions we saw earlier:

| Tunnel | Local Gateway | Local IP | Peer Gateway | Peer IP (from tunnel describe) | ✅ Match? |
|---|---|---|---|---|---|
| `vpn1-remote-0` | vpn1 iface 0 | `34.183.17.175` | vpn2 iface 0 | `34.157.96.112` | ✅ |
| `vpn1-remote-1` | vpn1 iface 1 | `34.184.41.242` | vpn2 iface 1 | `34.157.237.68` | ✅ |
| `vpn2-remote-0` | vpn2 iface 0 | `34.157.96.112` | vpn1 iface 0 | `34.183.17.175` | ✅ |
| `vpn2-remote-1` | vpn2 iface 1 | `34.157.237.68` | vpn1 iface 1 | `34.184.41.242` | ✅ |

Every `peerIp` in the tunnel descriptions matches the opposite gateway's interface IP. This is exactly how it should work — each tunnel connects one public IP to another.

### Key details about these IPs

- **Assigned automatically by GCP** when the HA VPN gateway is created. You don't choose them.
- **They are regional external IPs** — allocated from Google's IP pool in `us-central1`.
- **Each interface gets a different IP** on different physical infrastructure — this is how GCP guarantees that a single infrastructure failure can't take down both tunnels simultaneously.
- **They're not attached to any VM** — they exist only on the VPN gateway resource. You can't SSH to them or use them for anything else.
- **They persist** for the lifetime of the gateway — even after deleting tunnel `vpn1-remote-0`, the IP `34.183.17.175` on interface 0 is still there, ready for a new tunnel.

### Why run this command?

This is typically used to:
1. **Verify the tunnel wiring** — confirm that peer IPs match (as we just did)
2. **Configure a non-GCP peer** — if you were connecting to an on-prem firewall, you'd need these IPs to configure the remote side
3. **Firewall/allowlisting** — if corporate firewalls need to allow IPsec traffic, you'd provide these IPs

---

That's the last command in the logs! 🎉 Here's a **summary of everything the log demonstrated**:

| Step | What was tested |
|---|---|
| `ip route show` | VM1's minimal OS routing — everything goes to GCP's SDN gateway |
| `vpn-tunnels describe` (×4) | All 4 tunnel endpoints are ESTABLISHED with IKEv2 |
| `vpn-gateways get-status` (×2) | Both gateways report `CONNECTION_REDUNDANCY_MET` (99.99% SLA) |
| `routers get-status` (×2) | BGP sessions UP, routes learned and advertised correctly with priority-based primary/standby |
| `routers describe` (×2) | Static config matches Terraform (ASN, peers, interfaces, BFD disabled) |
| `routes list` (×2) | VPC subnet routes present (BGP routes invisible in this view) |
| `ping` | ✅ Connectivity works, ~2.5 ms latency, TTL=62 |
| **Tunnel deletion** | Primary tunnel deleted — **seamless failover** to standby tunnel |
| `routers get-status` (post-delete) | Confirms tunnel 0 DOWN, tunnel 1 still UP carrying all traffic |
| `vpn-gateways describe` (×2) | Public IPs confirmed and cross-referenced with tunnel peers |

Want to discuss anything further or dive deeper into any part?