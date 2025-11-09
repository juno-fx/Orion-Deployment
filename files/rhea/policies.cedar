permit (
  principal == default::KubernetesServiceAccount::"exampleservice",
  action == Action::"GET",
  resource == argocd::Service::"nonexistantservice"
);
