ActiveAdmin.register Channel do
  filter :name

  permit_params :name
end
