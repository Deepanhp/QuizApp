ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :username, :email, :password, :admin, :active_session_exists, :phone
  #
  # or
  #
  # permit_params do
  #   permitted = [:username, :email, :password_digest, :admin, :active_session_exists, :otp_secret_key, :phone]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  form do |f|
    f.semantic_errors # shows errors on :base

    f.inputs do
      f.input :username
      f.input :email
      f.input :phone
      f.input :password
      f.input :admin
      f.input :active_session_exists
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end
end
