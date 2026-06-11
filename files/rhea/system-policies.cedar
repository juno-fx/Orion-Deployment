permit (
  principal,
  action in
    [Action::"GET",
     Action::"POST",
     Action::"PUT",
     Action::"DELETE",
     Action::"PATCH"],
  resource == {{ .Release.Namespace }}::Service::"hubble"
)
when
{
  principal.serviceAccountName == "genesis" ||
  principal.serviceAccountName == "orion-hubble" ||
  principal.serviceAccountName == "kuiper" ||
  principal.serviceAccountName == "titan" ||
  principal.serviceAccountName == "terra"
};

permit (
  principal,
  action in
    [Action::"GET",
     Action::"POST",
     Action::"PUT",
     Action::"DELETE",
     Action::"PATCH"],
  resource == {{ .Release.Namespace }}::Service::"kuiper"
)
when
{
  principal.serviceAccountName == "genesis" ||
  principal.serviceAccountName == "orion-hubble" ||
  principal.serviceAccountName == "metrics-gatherer" ||
  principal.serviceAccountName == "kuiper" ||
  principal.serviceAccountName == "titan" ||
  principal.serviceAccountName == "terra"
};
