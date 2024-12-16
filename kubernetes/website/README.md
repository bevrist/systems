# Website Deployment

1) set up skaffold configs
2) update website external addresses
> search for `#! NOTE: update IP` and update relevant IP addresses as needed for external applications
3) build and deploy website: `skaffold run --cache-artifacts=false --namespace=website`
