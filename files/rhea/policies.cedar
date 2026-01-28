permit (
  principal,
  action in
    [Action::"GET",
     Action::"POST",
     Action::"PUT",
     Action::"DELETE",
     Action::"PATCH"],
  resource == {{ .Values.namespace }}::Service::"hubble"
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
  resource == {{ .Values.namespace }}::Service::"kuiper"
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
  resource == {{ .Values.genesis_namespace }}::Service::"titan"
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
  resource == {{ .Values.genesis_namespace }}::Service::"terra"
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
  resource == {{ .Values.genesis_namespace }}::Service::"genesis"
)
when
{
  principal.serviceAccountName == "genesis" ||
  principal.serviceAccountName == "orion-hubble" ||
  principal.serviceAccountName == "kuiper" ||
  principal.serviceAccountName == "titan" ||
  principal.serviceAccountName == "terra"
};