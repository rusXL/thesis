ruslan_melnyk_x_gmail_com@vm1:~$ ip route show
default via 10.0.1.1 dev ens4 proto dhcp src 10.0.1.2 metric 100 
10.0.1.1 dev ens4 proto dhcp scope link src 10.0.1.2 metric 100 
169.254.169.254 via 10.0.1.1 dev ens4 proto dhcp src 10.0.1.2 metric 100 

jus@Asus:~/projects/thesis$ gcloud compute vpn-tunnels describe vpn1-remote-0   --region=us-central1   --project=cloud-computing-476715
creationTimestamp: '2026-02-23T07:33:59.491-08:00'
description: ''
detailedStatus: Tunnel is up and running.
id: '7530176325595811208'
ikeVersion: 2
kind: compute#vpnTunnel
labelFingerprint: vezUS-42LLM=
labels:
  goog-terraform-provisioned: 'true'
localTrafficSelector:
- 0.0.0.0/0
name: vpn1-remote-0
peerGcpGateway: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnGateways/vpn2
peerIp: 34.157.96.112
region: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1
remoteTrafficSelector:
- 0.0.0.0/0
router: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/routers/vpn-vpn1
selfLink: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-0
sharedSecret: '*************'
sharedSecretHash: IsIPR6xrXY4fjFDwFliRmleryvZz
status: ESTABLISHED
vpnGateway: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnGateways/vpn1
vpnGatewayInterface: 0


jus@Asus:~/projects/thesis$ gcloud compute vpn-tunnels describe vpn1-remote-1   --region=us-central1   --project=cloud-computing-476715
creationTimestamp: '2026-02-23T07:33:59.978-08:00'
description: ''
detailedStatus: Tunnel is up and running.
id: '1197243018964487560'
ikeVersion: 2
kind: compute#vpnTunnel
labelFingerprint: vezUS-42LLM=
labels:
  goog-terraform-provisioned: 'true'
localTrafficSelector:
- 0.0.0.0/0
name: vpn1-remote-1
peerGcpGateway: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnGateways/vpn2
peerIp: 34.157.237.68
region: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1
remoteTrafficSelector:
- 0.0.0.0/0
router: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/routers/vpn-vpn1
selfLink: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-1
sharedSecret: '*************'
sharedSecretHash: -NNjDUFx2S3S-WxnLhNi6XpvSXhp
status: ESTABLISHED
vpnGateway: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnGateways/vpn1
vpnGatewayInterface: 1


jus@Asus:~/projects/thesis$ gcloud compute vpn-tunnels describe vpn2-remote-0   --region=us-central1   --project=cloud-computing-476715
creationTimestamp: '2026-02-23T07:33:58.408-08:00'
description: ''
detailedStatus: Tunnel is up and running.
id: '1356014005548862858'
ikeVersion: 2
kind: compute#vpnTunnel
labelFingerprint: vezUS-42LLM=
labels:
  goog-terraform-provisioned: 'true'
localTrafficSelector:
- 0.0.0.0/0
name: vpn2-remote-0
peerGcpGateway: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnGateways/vpn1
peerIp: 34.183.17.175
region: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1
remoteTrafficSelector:
- 0.0.0.0/0
router: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/routers/vpn-vpn2
selfLink: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-0
sharedSecret: '*************'
sharedSecretHash: e0seXwf29Os-vO2533TTHAm9bTbu
status: ESTABLISHED
vpnGateway: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnGateways/vpn2
vpnGatewayInterface: 0

jus@Asus:~/projects/thesis$ gcloud compute vpn-tunnels describe vpn2-remote-1   --region=us-central1   --project=cloud-computing-476715
creationTimestamp: '2026-02-23T07:33:58.298-08:00'
description: ''
detailedStatus: Tunnel is up and running.
id: '7406410722633174410'
ikeVersion: 2
kind: compute#vpnTunnel
labelFingerprint: vezUS-42LLM=
labels:
  goog-terraform-provisioned: 'true'
localTrafficSelector:
- 0.0.0.0/0
name: vpn2-remote-1
peerGcpGateway: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnGateways/vpn1
peerIp: 34.184.41.242
region: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1
remoteTrafficSelector:
- 0.0.0.0/0
router: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/routers/vpn-vpn2
selfLink: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-1
sharedSecret: '*************'
sharedSecretHash: JIwqSHEGRUwG0hh2v1FkU4mbb8Fu
status: ESTABLISHED
vpnGateway: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnGateways/vpn2
vpnGatewayInterface: 1


jus@Asus:~/projects/thesis$ gcloud compute vpn-gateways get-status vpn1 \
  --project=cloud-computing-476715 \
  --region=us-central1
result:
  vpnConnections:
  - peerGcpGateway: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnGateways/vpn2
    state:
      state: CONNECTION_REDUNDANCY_MET
    tunnels:
    - localGatewayInterface: 1
      peerGatewayInterface: 1
      tunnelUrl: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-1
    - localGatewayInterface: 0
      peerGatewayInterface: 0
      tunnelUrl: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-0



jus@Asus:~/projects/thesis$ gcloud compute vpn-gateways get-status vpn2   --project=cloud-computing-476715   --region=us-central1
result:
  vpnConnections:
  - peerGcpGateway: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnGateways/vpn1
    state:
      state: CONNECTION_REDUNDANCY_MET
    tunnels:
    - localGatewayInterface: 1
      peerGatewayInterface: 1
      tunnelUrl: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-1
    - localGatewayInterface: 0
      peerGatewayInterface: 0
      tunnelUrl: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-0


jus@Asus:~/projects/thesis$ gcloud compute routers get-status vpn-vpn1 \
  --project=cloud-computing-476715 \
  --region=us-central1
kind: compute#routerStatusResponse
result:
  bestRoutes:
  - asPaths:
    - asLists:
      - 64515
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:04.995-08:00'
    destRange: 192.168.2.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1
    nextHopIp: 169.254.0.2
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-0
    priority: 333
    routeType: BGP
  - asPaths:
    - asLists:
      - 64515
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:04.994-08:00'
    destRange: 192.168.1.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1
    nextHopIp: 169.254.0.2
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-0
    priority: 100
    routeType: BGP
  - asPaths:
    - asLists:
      - 64515
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:11.967-08:00'
    destRange: 192.168.1.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1
    nextHopIp: 169.254.1.2
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-1
    priority: 200
    routeType: BGP
  - asPaths:
    - asLists:
      - 64515
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:11.972-08:00'
    destRange: 192.168.2.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1
    nextHopIp: 169.254.1.2
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-1
    priority: 433
    routeType: BGP
  bestRoutesForRouter:
  - asPaths:
    - asLists:
      - 64515
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:04.994-08:00'
    destRange: 192.168.1.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1
    nextHopIp: 169.254.0.2
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-0
    priority: 100
    routeStatus: ACTIVE
    routeType: BGP
  - asPaths:
    - asLists:
      - 64515
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:04.995-08:00'
    destRange: 192.168.2.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1
    nextHopIp: 169.254.0.2
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-0
    priority: 333
    routeStatus: ACTIVE
    routeType: BGP
  - asPaths:
    - asLists:
      - 64515
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:11.967-08:00'
    destRange: 192.168.1.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1
    nextHopIp: 169.254.1.2
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-1
    priority: 200
    routeStatus: ACTIVE
    routeType: BGP
  - asPaths:
    - asLists:
      - 64515
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:11.972-08:00'
    destRange: 192.168.2.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1
    nextHopIp: 169.254.1.2
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-1
    priority: 433
    routeStatus: ACTIVE
    routeType: BGP
  bgpPeerStatus:
  - advertisedRoutes:
    - destRange: 10.0.1.0/24
      kind: compute#route
      network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1
      nextHopIp: 169.254.0.1
      nextHopOrigin: INCOMPLETE
      nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-0
      priority: 100
      routeType: BGP
    - destRange: 10.0.2.0/24
      kind: compute#route
      network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1
      nextHopIp: 169.254.0.1
      nextHopOrigin: INCOMPLETE
      nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-0
      priority: 338
      routeType: BGP
    enableIpv4: true
    enableIpv6: false
    ipAddress: 169.254.0.1
    linkedVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-0
    md5AuthEnabled: false
    name: vpn1-remote-0
    numLearnedRoutes: 2
    peerIpAddress: 169.254.0.2
    state: Established
    status: UP
    uptime: 7 minutes, 42 seconds
    uptimeSeconds: '462'
  - advertisedRoutes:
    - destRange: 10.0.1.0/24
      kind: compute#route
      network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1
      nextHopIp: 169.254.1.1
      nextHopOrigin: INCOMPLETE
      nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-1
      priority: 200
      routeType: BGP
    - destRange: 10.0.2.0/24
      kind: compute#route
      network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1
      nextHopIp: 169.254.1.1
      nextHopOrigin: INCOMPLETE
      nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-1
      priority: 438
      routeType: BGP
    enableIpv4: true
    enableIpv6: false
    ipAddress: 169.254.1.1
    linkedVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-1
    md5AuthEnabled: false
    name: vpn1-remote-1
    numLearnedRoutes: 2
    peerIpAddress: 169.254.1.2
    state: Established
    status: UP
    uptime: 7 minutes, 42 seconds
    uptimeSeconds: '462'
  network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1

jus@Asus:~/projects/thesis$ gcloud compute routers get-status vpn-vpn2   --project=cloud-computing-476715   --region=us-central1
kind: compute#routerStatusResponse
result:
  bestRoutes:
  - asPaths:
    - asLists:
      - 64514
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:04.979-08:00'
    destRange: 10.0.2.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network2
    nextHopIp: 169.254.0.1
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-0
    priority: 338
    routeType: BGP
  - asPaths:
    - asLists:
      - 64514
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:04.978-08:00'
    destRange: 10.0.1.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network2
    nextHopIp: 169.254.0.1
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-0
    priority: 100
    routeType: BGP
  - asPaths:
    - asLists:
      - 64514
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:11.966-08:00'
    destRange: 10.0.2.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network2
    nextHopIp: 169.254.1.1
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-1
    priority: 438
    routeType: BGP
  - asPaths:
    - asLists:
      - 64514
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:11.964-08:00'
    destRange: 10.0.1.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network2
    nextHopIp: 169.254.1.1
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-1
    priority: 200
    routeType: BGP
  bestRoutesForRouter:
  - asPaths:
    - asLists:
      - 64514
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:04.978-08:00'
    destRange: 10.0.1.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network2
    nextHopIp: 169.254.0.1
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-0
    priority: 100
    routeStatus: ACTIVE
    routeType: BGP
  - asPaths:
    - asLists:
      - 64514
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:04.979-08:00'
    destRange: 10.0.2.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network2
    nextHopIp: 169.254.0.1
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-0
    priority: 338
    routeStatus: ACTIVE
    routeType: BGP
  - asPaths:
    - asLists:
      - 64514
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:11.964-08:00'
    destRange: 10.0.1.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network2
    nextHopIp: 169.254.1.1
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-1
    priority: 200
    routeStatus: ACTIVE
    routeType: BGP
  - asPaths:
    - asLists:
      - 64514
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:11.966-08:00'
    destRange: 10.0.2.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network2
    nextHopIp: 169.254.1.1
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-1
    priority: 438
    routeStatus: ACTIVE
    routeType: BGP
  bgpPeerStatus:
  - advertisedRoutes:
    - destRange: 192.168.1.0/24
      kind: compute#route
      network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network2
      nextHopIp: 169.254.0.2
      nextHopOrigin: INCOMPLETE
      nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-0
      priority: 100
      routeType: BGP
    - destRange: 192.168.2.0/24
      kind: compute#route
      network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network2
      nextHopIp: 169.254.0.2
      nextHopOrigin: INCOMPLETE
      nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-0
      priority: 333
      routeType: BGP
    enableIpv4: true
    enableIpv6: false
    ipAddress: 169.254.0.2
    linkedVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-0
    md5AuthEnabled: false
    name: vpn2-remote-0
    numLearnedRoutes: 2
    peerIpAddress: 169.254.0.1
    state: Established
    status: UP
    uptime: 8 minutes, 0 seconds
    uptimeSeconds: '480'
  - advertisedRoutes:
    - destRange: 192.168.1.0/24
      kind: compute#route
      network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network2
      nextHopIp: 169.254.1.2
      nextHopOrigin: INCOMPLETE
      nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-1
      priority: 200
      routeType: BGP
    - destRange: 192.168.2.0/24
      kind: compute#route
      network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network2
      nextHopIp: 169.254.1.2
      nextHopOrigin: INCOMPLETE
      nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-1
      priority: 433
      routeType: BGP
    enableIpv4: true
    enableIpv6: false
    ipAddress: 169.254.1.2
    linkedVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-1
    md5AuthEnabled: false
    name: vpn2-remote-1
    numLearnedRoutes: 2
    peerIpAddress: 169.254.1.1
    state: Established
    status: UP
    uptime: 8 minutes, 0 seconds
    uptimeSeconds: '480'
  network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network2



jus@Asus:~/projects/thesis$ gcloud compute routers describe vpn-vpn1 \
  --project=cloud-computing-476715 \
  --region=us-central1
bgp:
  advertiseMode: DEFAULT
  asn: 64514
  keepaliveInterval: 20
bgpPeers:
- advertiseMode: DEFAULT
  advertisedRoutePriority: 200
  bfd:
    minReceiveInterval: 1000
    minTransmitInterval: 1000
    multiplier: 5
    sessionInitializationMode: DISABLED
  enable: 'TRUE'
  enableIpv4: true
  enableIpv6: false
  interfaceName: vpn1-remote-1
  ipAddress: 169.254.1.1
  name: vpn1-remote-1
  peerAsn: 64515
  peerIpAddress: 169.254.1.2
- advertiseMode: DEFAULT
  advertisedRoutePriority: 100
  bfd:
    minReceiveInterval: 1000
    minTransmitInterval: 1000
    multiplier: 5
    sessionInitializationMode: DISABLED
  enable: 'TRUE'
  enableIpv4: true
  enableIpv6: false
  interfaceName: vpn1-remote-0
  ipAddress: 169.254.0.1
  name: vpn1-remote-0
  peerAsn: 64515
  peerIpAddress: 169.254.0.2
creationTimestamp: '2026-02-23T07:33:35.629-08:00'
encryptedInterconnectRouter: false
id: '4509134013632466336'
interfaces:
- ipRange: 169.254.1.1/30
  ipVersion: IPV4
  linkedVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-1
  name: vpn1-remote-1
- ipRange: 169.254.0.1/30
  ipVersion: IPV4
  linkedVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-0
  name: vpn1-remote-0
kind: compute#router
name: vpn-vpn1
network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1
region: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1
selfLink: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/routers/vpn-vpn1


jus@Asus:~/projects/thesis$ gcloud compute routers describe vpn-vpn2   --project=cloud-computing-476715   --region=us-central1

bgp:
  advertiseMode: DEFAULT
  asn: 64515
  keepaliveInterval: 20
bgpPeers:
- advertiseMode: DEFAULT
  advertisedRoutePriority: 100
  bfd:
    minReceiveInterval: 1000
    minTransmitInterval: 1000
    multiplier: 5
    sessionInitializationMode: DISABLED
  enable: 'TRUE'
  enableIpv4: true
  enableIpv6: false
  interfaceName: vpn2-remote-0
  ipAddress: 169.254.0.2
  name: vpn2-remote-0
  peerAsn: 64514
  peerIpAddress: 169.254.0.1
- advertiseMode: DEFAULT
  advertisedRoutePriority: 200
  bfd:
    minReceiveInterval: 1000
    minTransmitInterval: 1000
    multiplier: 5
    sessionInitializationMode: DISABLED
  enable: 'TRUE'
  enableIpv4: true
  enableIpv6: false
  interfaceName: vpn2-remote-1
  ipAddress: 169.254.1.2
  name: vpn2-remote-1
  peerAsn: 64514
  peerIpAddress: 169.254.1.1
creationTimestamp: '2026-02-23T07:33:36.083-08:00'
encryptedInterconnectRouter: false
id: '4292951134050569632'
interfaces:
- ipRange: 169.254.1.2/30
  ipVersion: IPV4
  linkedVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-1
  name: vpn2-remote-1
- ipRange: 169.254.0.2/30
  ipVersion: IPV4
  linkedVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn2-remote-0
  name: vpn2-remote-0
kind: compute#router
name: vpn-vpn2
network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network2
region: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1
selfLink: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/routers/vpn-vpn2




jus@Asus:~/projects/thesis$ gcloud compute routes list \
    --filter="network=network1" \
    --project=cloud-computing-476715
NAME                              NETWORK   DEST_RANGE   NEXT_HOP                  PRIORITY
default-route-b54416d0484b0fa2    network1  0.0.0.0/0    default-internet-gateway  1000
default-route-r-1074fe19a35135f3  network1  10.0.2.0/24  network1                  0
default-route-r-57cd89aabaf6732f  network1  10.0.1.0/24  network1                  0


jus@Asus:~/projects/thesis$ gcloud compute routes list     --filter="network=network2"     --project=cloud-computing-476715
NAME                              NETWORK   DEST_RANGE      NEXT_HOP                  PRIORITY
default-route-607978e70fb30790    network2  0.0.0.0/0       default-internet-gateway  1000
default-route-r-5360d6df0283659d  network2  192.168.2.0/24  network2                  0
default-route-r-c819fb1392fc0751  network2  192.168.1.0/24  network2                  0




Ping

ruslan_melnyk_x_gmail_com@vm1:~$ ping 192.168.1.2
PING 192.168.1.2 (192.168.1.2) 56(84) bytes of data.
64 bytes from 192.168.1.2: icmp_seq=1 ttl=62 time=2.82 ms
64 bytes from 192.168.1.2: icmp_seq=2 ttl=62 time=2.81 ms
64 bytes from 192.168.1.2: icmp_seq=3 ttl=62 time=2.77 ms
64 bytes from 192.168.1.2: icmp_seq=4 ttl=62 time=2.92 ms
64 bytes from 192.168.1.2: icmp_seq=5 ttl=62 time=2.59 ms
64 bytes from 192.168.1.2: icmp_seq=6 ttl=62 time=2.61 ms
64 bytes from 192.168.1.2: icmp_seq=7 ttl=62 time=2.59 ms
64 bytes from 192.168.1.2: icmp_seq=8 ttl=62 time=2.47 ms
64 bytes from 192.168.1.2: icmp_seq=9 ttl=62 time=2.59 ms
64 bytes from 192.168.1.2: icmp_seq=10 ttl=62 time=2.58 ms
64 bytes from 192.168.1.2: icmp_seq=11 ttl=62 time=2.86 ms


64 bytes from 192.168.1.2: icmp_seq=35 ttl=62 time=3.60 ms
64 bytes from 192.168.1.2: icmp_seq=36 ttl=62 time=2.18 ms
64 bytes from 192.168.1.2: icmp_seq=37 ttl=62 time=2.19 ms
64 bytes from 192.168.1.2: icmp_seq=38 ttl=62 time=2.17 ms
64 bytes from 192.168.1.2: icmp_seq=39 ttl=62 time=2.17 ms
64 bytes from 192.168.1.2: icmp_seq=40 ttl=62 time=2.24 ms
64 bytes from 192.168.1.2: icmp_seq=41 ttl=62 time=2.10 ms
64 bytes from 192.168.1.2: icmp_seq=42 ttl=62 time=2.23 ms
64 bytes from 192.168.1.2: icmp_seq=43 ttl=62 time=2.15 ms
64 bytes from 192.168.1.2: icmp_seq=44 ttl=62 time=2.26 ms
64 bytes from 192.168.1.2: icmp_seq=45 ttl=62 time=2.17 ms
64 bytes from 192.168.1.2: icmp_seq=46 ttl=62 time=2.24 ms
64 bytes from 192.168.1.2: icmp_seq=47 ttl=62 time=2.26 ms
64 bytes from 192.168.1.2: icmp_seq=48 ttl=62 time=2.17 ms
64 bytes from 192.168.1.2: icmp_seq=49 ttl=62 time=2.31 ms
64 bytes from 192.168.1.2: icmp_seq=50 ttl=62 time=2.10 ms
64 bytes from 192.168.1.2: icmp_seq=51 ttl=62 time=2.19 ms

jus@Asus:~/projects/thesis$ gcloud compute vpn-tunnels delete vpn1-remote-0 \
  --region=us-central1 \
  --project=cloud-computing-476715
The following vpn tunnels will be deleted:
 - [vpn1-remote-0] in [us-central1]

Do you want to continue (Y/n)?  Y

Deleting VPN tunnel...done.                                                                  
jus@Asus:~/projects/thesis$ gcloud compute routers get-status vpn-vpn1 \
  --project=cloud-computing-476715 \
  --region=us-central1
kind: compute#routerStatusResponse
result:
  bestRoutes:
  - asPaths:
    - asLists:
      - 64515
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:11.972-08:00'
    destRange: 192.168.2.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1
    nextHopIp: 169.254.1.2
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-1
    priority: 433
    routeType: BGP
  - asPaths:
    - asLists:
      - 64515
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:11.967-08:00'
    destRange: 192.168.1.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1
    nextHopIp: 169.254.1.2
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-1
    priority: 200
    routeType: BGP
  bestRoutesForRouter:
  - asPaths:
    - asLists:
      - 64515
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:11.967-08:00'
    destRange: 192.168.1.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1
    nextHopIp: 169.254.1.2
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-1
    priority: 200
    routeStatus: ACTIVE
    routeType: BGP
  - asPaths:
    - asLists:
      - 64515
      pathSegmentType: AS_SEQUENCE
    creationTimestamp: '2026-02-23T07:35:11.972-08:00'
    destRange: 192.168.2.0/24
    kind: compute#route
    network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1
    nextHopIp: 169.254.1.2
    nextHopOrigin: INCOMPLETE
    nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-1
    priority: 433
    routeStatus: ACTIVE
    routeType: BGP
  bgpPeerStatus:
  - enableIpv4: true
    enableIpv6: false
    ipAddress: 169.254.0.1
    linkedVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-0
    md5AuthEnabled: false
    name: vpn1-remote-0
    peerIpAddress: 169.254.0.2
    state: The VPN tunnel or Interconnect attachment is unknown.
    status: DOWN
  - advertisedRoutes:
    - destRange: 10.0.1.0/24
      kind: compute#route
      network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1
      nextHopIp: 169.254.1.1
      nextHopOrigin: INCOMPLETE
      nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-1
      priority: 200
      routeType: BGP
    - destRange: 10.0.2.0/24
      kind: compute#route
      network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1
      nextHopIp: 169.254.1.1
      nextHopOrigin: INCOMPLETE
      nextHopVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-1
      priority: 438
      routeType: BGP
    enableIpv4: true
    enableIpv6: false
    ipAddress: 169.254.1.1
    linkedVpnTunnel: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/regions/us-central1/vpnTunnels/vpn1-remote-1
    md5AuthEnabled: false
    name: vpn1-remote-1
    numLearnedRoutes: 2
    peerIpAddress: 169.254.1.2
    state: Established
    status: UP
    uptime: 13 minutes, 10 seconds
    uptimeSeconds: '790'
  network: https://www.googleapis.com/compute/v1/projects/cloud-computing-476715/global/networks/network1


jus@Asus:~/projects/thesis$ gcloud compute vpn-gateways describe vpn1 \
  --region=us-central1 \
  --project=cloud-computing-476715 \
  --format='yaml(vpnInterfaces)'
vpnInterfaces:
- id: 0
  ipAddress: 34.183.17.175
- id: 1
  ipAddress: 34.184.41.242
jus@Asus:~/projects/thesis$ 

jus@Asus:~/projects/thesis$ gcloud compute vpn-gateways describe vpn2   --region=us-central1  
 --project=cloud-computing-476715   --format='yaml(vpnInterfaces)'
vpnInterfaces:
- id: 0
  ipAddress: 34.157.96.112
- id: 1
  ipAddress: 34.157.237.68
  