ActiveAdmin.register Stream do

  filter :id
  filter :user
  filter :channels
  filter :caption
  filter :started_on

  permit_params :user, :channel, :caption, :started_on

  # list configuration
  index do
    column :id
    column :user
    column :channels
    column :caption
    column :started_on

    actions
  end

  # edit and create configuration
  form do |f|
    f.inputs do
      f.input :user
      f.input :caption
      f.input :started_on
    end
  end

  show do
    attributes_table do
      row :user
      row :caption
      row :channels
      row :started_on
    end
  end

  
  
end
