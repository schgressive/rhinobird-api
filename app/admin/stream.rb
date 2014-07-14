ActiveAdmin.register Stream do

  filter :id
  filter :user
  filter :channels
  filter :caption
  filter :started_on

  permit_params :user_id, :caption, :started_on

  # list configuration
  index do
    column :id
    column :user
    column :caption
    column :started_on

    actions
  end

  # edit and create configuration
  form do |f|
    f.inputs do
      f.input :user
      f.input :caption
    end
    f.actions
  end

  show do
    attributes_table do
      row :user
      row :caption
      row :started_on
    end
  end

end
