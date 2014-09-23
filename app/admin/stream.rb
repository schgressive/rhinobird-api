ActiveAdmin.register Stream do

  filter :id
  filter :user
  filter :promoted
  filter :channels
  filter :caption
  filter :status, as: :select, collection: Stream.status.values.map {|v| [v.text, v.value]}
  filter :started_on

  permit_params :user_id, :caption, :started_on, :promoted, :status

  # list configuration
  index do
    column :id
    column :user
    column :caption
    column :promoted
    column :status
    column :started_on

    actions
  end

  # edit and create configuration
  form do |f|
    f.inputs do
      f.input :user
      f.input :caption
      f.input :promoted
      f.input :status, as: :select
    end
    f.actions
  end

  show do
    attributes_table do
      row :user
      row :caption
      row :promoted
      row :status
      row :started_on
    end
  end

end
