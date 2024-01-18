# Website Deployment

1) set up skaffold configs
2) update website external addresses
> search for `#! NOTE: update IP` and update relevant IP addresses as needed for external applications
3) build website containers: `skaffold build --cache-artifacts=false`
4) deploy website: `skaffold run --cache-artifacts=false`
