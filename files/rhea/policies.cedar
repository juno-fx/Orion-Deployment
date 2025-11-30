permit (
  principal,
  action in
    [Action::"GET",
     Action::"POST",
     Action::"PUT",
     Action::"DELETE",
     Action::"PATCH"],
  resource == argocd::Service::"hubble"
);

permit (
  principal,
  action in
    [Action::"GET",
     Action::"POST",
     Action::"PUT",
     Action::"DELETE",
     Action::"PATCH"],
  resource == argocd::Service::"kuiper"
);
