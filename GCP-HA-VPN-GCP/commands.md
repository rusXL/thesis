- list all VPN tunnels of the project with 
```bash
gcloud compute vpn-tunnels list \
  --project=cloud-computing-476715
```

- list tunnels 
```bash
gcloud compute vpn-gateways describe GW_NAME \
  --region=us-central1 \
  --project=cloud-computing-476715 \
  --format='flattened(tunnels)'
```

- tunnel status
```bash
gcloud compute vpn-tunnels describe NAME \
  --region=us-central1 \
  --project=cloud-computing-476715 \
```

- check HA status with
```bash
gcloud compute vpn-gateways get-status vpn1 \
  --project=cloud-computing-476715 \
  --region=us-central1
```

- check router status with
```bash
gcloud compute routers get-status router1 \
  --project=cloud-computing-476715 \
  --region=us-central1
```

- check BGP session config with
```bash
gcloud compute routers describe router1 \
  --project=cloud-computing-476715 \
  --region=us-central1
```

- ssh to vm1
```bash
gcloud compute ssh test-vm1 --zone=us-central1-a --tunnel-through-iap
```

- ping vm2
```bash
ping 192.168.1.2
```
```bash
traceroute 192.168.1.2
```
```bash
ip route show
```

- list vpc routes
```bash
gcloud compute routes list \
    --filter="network=network1" \
    --project=cloud-computing-476715
```

- go to [logs explorer](https://console.cloud.google.com/logs)

- go to [vpn observability/monitoring](https://console.cloud.google.com/hybrid/vpn/list)
