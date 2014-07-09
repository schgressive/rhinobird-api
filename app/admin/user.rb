ActiveAdmin.register User do
  filter :id
  filter :name
  filter :username
  filter :email

  permit_params :name, :email, :username

  # list configuration
  index do
    column :id
    column :name
    column :username
    column :email
    column :confirmed_at

    actions
  end

  # edit and create configuration
  form do |f|
    f.inputs I18n.t(:fields) do
      f.input :name
      f.input :username
      f.input :email
    end
  end

  show do
    attributes_table do
      row :name
      row :email
      row :username
      row :confirmed_at
    end
  end

  
end
