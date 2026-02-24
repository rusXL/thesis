# ══════════════════════════════════════════════
# GCP — HA VPN Gateway + Cloud Router
# (created first: provides the public IPs that
#  AWS Customer Gateways need)
# ══════════════════════════════════════════════

resource "google_compute_ha_vpn_gateway" "vpn_gw_g" {
  name    = "vpn-gw-g"
  network = google_compute_network.vpc_g.id
  region  = var.gcp_region
}

resource "google_compute_router" "router_g" {
  name    = "router-g"
  network = google_compute_network.vpc_g.id
  region  = var.gcp_region

  bgp {
    asn = var.gcp_bgp_asn
  }
}

# ══════════════════════════════════════════════
# AWS — VPN Gateway
# ══════════════════════════════════════════════

resource "aws_vpn_gateway" "vpn_gw_a" {
  vpc_id          = aws_vpc.vpc_a.id
  amazon_side_asn = var.aws_bgp_asn

  tags = { Name = "vpn-gw-a" }
}

resource "aws_vpn_gateway_route_propagation" "rt_propagation" {
  vpn_gateway_id = aws_vpn_gateway.vpn_gw_a.id
  route_table_id = aws_route_table.rt_a.id
}

# ══════════════════════════════════════════════
# AWS — Customer Gateways (one per GCP interface)
# ══════════════════════════════════════════════

resource "aws_customer_gateway" "cgw_0" {
  bgp_asn    = var.gcp_bgp_asn
  ip_address = google_compute_ha_vpn_gateway.vpn_gw_g.vpn_interfaces[0].ip_address
  type       = "ipsec.1"

  tags = { Name = "cgw-g-if0" }
}

resource "aws_customer_gateway" "cgw_1" {
  bgp_asn    = var.gcp_bgp_asn
  ip_address = google_compute_ha_vpn_gateway.vpn_gw_g.vpn_interfaces[1].ip_address
  type       = "ipsec.1"

  tags = { Name = "cgw-g-if1" }
}

# ══════════════════════════════════════════════
# AWS — VPN Connections (one per CGW = 2 tunnels each)
# ══════════════════════════════════════════════

resource "aws_vpn_connection" "vpn_conn_0" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gw_a.id
  customer_gateway_id = aws_customer_gateway.cgw_0.id
  type                = "ipsec.1"
  static_routes_only  = false # BGP

  tunnel1_preshared_key = var.vpn_psk
  tunnel2_preshared_key = var.vpn_psk

  tags = { Name = "vpn-conn-g-if0" }
}

resource "aws_vpn_connection" "vpn_conn_1" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gw_a.id
  customer_gateway_id = aws_customer_gateway.cgw_1.id
  type                = "ipsec.1"
  static_routes_only  = false # BGP

  tunnel1_preshared_key = var.vpn_psk
  tunnel2_preshared_key = var.vpn_psk

  tags = { Name = "vpn-conn-g-if1" }
}

# ══════════════════════════════════════════════
# GCP — External VPN Gateway (represents AWS VGW)
#        4 interfaces = 4 AWS tunnel endpoints
# ══════════════════════════════════════════════

resource "google_compute_external_vpn_gateway" "ext_vpn_gw_a" {
  name            = "ext-vpn-gw-a"
  redundancy_type = "FOUR_IPS_REDUNDANCY"
  description     = "AWS VPN Gateway tunnel endpoints"

  interface {
    id         = 0
    ip_address = aws_vpn_connection.vpn_conn_0.tunnel1_address
  }

  interface {
    id         = 1
    ip_address = aws_vpn_connection.vpn_conn_0.tunnel2_address
  }

  interface {
    id         = 2
    ip_address = aws_vpn_connection.vpn_conn_1.tunnel1_address
  }

  interface {
    id         = 3
    ip_address = aws_vpn_connection.vpn_conn_1.tunnel2_address
  }
}

# ══════════════════════════════════════════════
# GCP — VPN Tunnels (4 total, one per AWS tunnel)
# ══════════════════════════════════════════════

# --- Connection 0, Tunnel 1 ---
resource "google_compute_vpn_tunnel" "tunnel_0" {
  name                            = "tunnel-0"
  region                          = var.gcp_region
  vpn_gateway                     = google_compute_ha_vpn_gateway.vpn_gw_g.id
  vpn_gateway_interface           = 0
  peer_external_gateway           = google_compute_external_vpn_gateway.ext_vpn_gw_a.id
  peer_external_gateway_interface = 0
  shared_secret                   = var.vpn_psk
  router                          = google_compute_router.router_g.id
  ike_version                     = 2
}

# --- Connection 0, Tunnel 2 ---
resource "google_compute_vpn_tunnel" "tunnel_1" {
  name                            = "tunnel-1"
  region                          = var.gcp_region
  vpn_gateway                     = google_compute_ha_vpn_gateway.vpn_gw_g.id
  vpn_gateway_interface           = 0
  peer_external_gateway           = google_compute_external_vpn_gateway.ext_vpn_gw_a.id
  peer_external_gateway_interface = 1
  shared_secret                   = var.vpn_psk
  router                          = google_compute_router.router_g.id
  ike_version                     = 2
}

# --- Connection 1, Tunnel 1 ---
resource "google_compute_vpn_tunnel" "tunnel_2" {
  name                            = "tunnel-2"
  region                          = var.gcp_region
  vpn_gateway                     = google_compute_ha_vpn_gateway.vpn_gw_g.id
  vpn_gateway_interface           = 1
  peer_external_gateway           = google_compute_external_vpn_gateway.ext_vpn_gw_a.id
  peer_external_gateway_interface = 2
  shared_secret                   = var.vpn_psk
  router                          = google_compute_router.router_g.id
  ike_version                     = 2
}

# --- Connection 1, Tunnel 2 ---
resource "google_compute_vpn_tunnel" "tunnel_3" {
  name                            = "tunnel-3"
  region                          = var.gcp_region
  vpn_gateway                     = google_compute_ha_vpn_gateway.vpn_gw_g.id
  vpn_gateway_interface           = 1
  peer_external_gateway           = google_compute_external_vpn_gateway.ext_vpn_gw_a.id
  peer_external_gateway_interface = 3
  shared_secret                   = var.vpn_psk
  router                          = google_compute_router.router_g.id
  ike_version                     = 2
}

# ══════════════════════════════════════════════
# GCP — Cloud Router interfaces + BGP peers
#        (one pair per tunnel)
# ══════════════════════════════════════════════

# --- Tunnel 0 ---
resource "google_compute_router_interface" "router_if_0" {
  name       = "router-if-0"
  router     = google_compute_router.router_g.name
  region     = var.gcp_region
  ip_range   = "${aws_vpn_connection.vpn_conn_0.tunnel1_cgw_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_0.name
}

resource "google_compute_router_peer" "bgp_peer_0" {
  name                      = "bgp-peer-0"
  router                    = google_compute_router.router_g.name
  region                    = var.gcp_region
  peer_ip_address           = aws_vpn_connection.vpn_conn_0.tunnel1_vgw_inside_address
  peer_asn                  = var.aws_bgp_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router_if_0.name
}

# --- Tunnel 1 ---
resource "google_compute_router_interface" "router_if_1" {
  name       = "router-if-1"
  router     = google_compute_router.router_g.name
  region     = var.gcp_region
  ip_range   = "${aws_vpn_connection.vpn_conn_0.tunnel2_cgw_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_1.name
}

resource "google_compute_router_peer" "bgp_peer_1" {
  name                      = "bgp-peer-1"
  router                    = google_compute_router.router_g.name
  region                    = var.gcp_region
  peer_ip_address           = aws_vpn_connection.vpn_conn_0.tunnel2_vgw_inside_address
  peer_asn                  = var.aws_bgp_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router_if_1.name
}

# --- Tunnel 2 ---
resource "google_compute_router_interface" "router_if_2" {
  name       = "router-if-2"
  router     = google_compute_router.router_g.name
  region     = var.gcp_region
  ip_range   = "${aws_vpn_connection.vpn_conn_1.tunnel1_cgw_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_2.name
}

resource "google_compute_router_peer" "bgp_peer_2" {
  name                      = "bgp-peer-2"
  router                    = google_compute_router.router_g.name
  region                    = var.gcp_region
  peer_ip_address           = aws_vpn_connection.vpn_conn_1.tunnel1_vgw_inside_address
  peer_asn                  = var.aws_bgp_asn
  advertised_route_priority = 200
  interface                 = google_compute_router_interface.router_if_2.name
}

# --- Tunnel 3 ---
resource "google_compute_router_interface" "router_if_3" {
  name       = "router-if-3"
  router     = google_compute_router.router_g.name
  region     = var.gcp_region
  ip_range   = "${aws_vpn_connection.vpn_conn_1.tunnel2_cgw_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_3.name
}

resource "google_compute_router_peer" "bgp_peer_3" {
  name                      = "bgp-peer-3"
  router                    = google_compute_router.router_g.name
  region                    = var.gcp_region
  peer_ip_address           = aws_vpn_connection.vpn_conn_1.tunnel2_vgw_inside_address
  peer_asn                  = var.aws_bgp_asn
  advertised_route_priority = 200
  interface                 = google_compute_router_interface.router_if_3.name
}
