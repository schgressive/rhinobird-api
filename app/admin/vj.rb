ActiveAdmin.register Vj do

  filter :id
  filter :user
  filter :channel
  filter :status, as: :select, collection: Vj.status.values.map {|v| [v.text, v.value]}

  permit_params :user_id, :archived_url, :channel_id, :status

  # list configuration
  index do
    column :id
    column :user
    column :channel
    column :status

    actions
  end

  # edit and create configuration
  form do |f|
    f.inputs do
      f.input :user
      f.input :channel
      f.input :status, as: :select
      f.input :archived_url
    end
    f.actions
  end

  show do
    attributes_table do
      row :user
      row :channel
      row :archived_url
      row :status
    end
  end

  
end
