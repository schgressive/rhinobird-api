ActiveAdmin.register Vj do

  filter :id
  filter :user
  filter :channel

  permit_params :user, :archived_url, :channel

  # list configuration
  index do
    column :id
    column :user
    column :channel

    actions
  end

  # edit and create configuration
  form do |f|
    f.inputs do
      f.input :user
      f.input :channel
      f.input :archived_url
    end
  end

  show do
    attributes_table do
      row :user
      row :channel
      row :archived_url
    end
  end

  
end
