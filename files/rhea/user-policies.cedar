// Admins can do anything they want
permit (
  principal in Group::"admin",
  action,
  resource
);

// These are wide open
permit (principal, action, resource)
when
{
  context.url like "*/workloads*" ||
  context.url like "*/home/" ||
  context.url like "*/settings/"
};

// Kuiper group access
permit (
  principal in Group::"kuiper",
  action,
  resource
)
when 
{
  context.url like "*/kuiper/*" ||
  context.url like "*/development*"
};
