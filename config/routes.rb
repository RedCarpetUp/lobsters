Lobsters::Application.routes.draw do
  #devise_for :users, :skip => [:sessions], :controllers => { :omniauth_callbacks => "omniauth_callbacks", :registrations => "registrations" }
  devise_for :users, :skip => [:sessions], :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  scope :format => "html" do
    root :to => "home#index",
      :protocol => (Rails.application.config.force_ssl ? "https://" : "http://"),
      :as => "root"

    get "/rss" => "home#index", :format => "rss"
    get "/hottest" => "home#index", :format => "json"

    get "/page/:page" => "home#index"

    get "/newest" => "home#newest", :format => /html|json|rss/
    get "/newest/page/:page" => "home#newest"
    get "/newest/:user" => "home#newest_by_user", :format => /html|json|rss/
    get "/newest/:user/page/:page" => "home#newest_by_user"
    get "/recent" => "home#recent"
    get "/recent/page/:page" => "home#recent"
    get "/hidden" => "home#hidden"
    get "/hidden/page/:page" => "home#hidden"

    get "/upvoted(.format)" => "home#upvoted"
    get "/upvoted/page/:page" => "home#upvoted"

    get "/top" => "home#top"
    get "/top/page/:page" => "home#top"
    get "/top/:length" => "home#top"
    get "/top/:length/page/:page" => "home#top"

    get "/threads" => "comments#threads"
    get "/threads/:user" => "comments#threads"

    get "/login" => "login#index"
    post "/login" => "login#login"
    post "/logout" => "login#logout"

    get "/signup" => "signup#index"
    post "/signup" => "signup#signup"
    get "/signup/invite" => "signup#invite"

    get "/login/forgot_password" => "login#forgot_password",
      :as => "forgot_password"
    post "/login/reset_password" => "login#reset_password",
      :as => "reset_password"
    match "/login/set_new_password" => "login#set_new_password",
      :as => "set_new_password", :via => [:get, :post]

    get "/t/:tag" => "home#tagged", :as => "tag", :format => /html|rss|json/
    get "/t/:tag/page/:page" => "home#tagged"

    get "/search" => "search#index"
    get "/search/:q" => "search#index"

    resources :bookings, :except => [:show, :new]

    get "/investors" => "investors#index"
    get "/investors/page/:page" => "investors#index"

    resources :stories do
      post "upvote"
      post "downvote"
      post "unvote"
      post "undelete"
      post "hide"
      post "unhide"
      get "suggest"
      post "suggest", :action => "submit_suggestions"
    end
    post "/stories/fetch_url_attributes", :format => "json"
    post "/stories/preview" => "stories#preview"

    resources :comments do
      member do
        get "reply"
        post "upvote"
        post "downvote"
        post "unvote"

        post "delete"
        post "undelete"
      end
    end
    get "/comments/page/:page" => "comments#index"
    get "/comments" => "comments#index", :format => /html|rss/

    get "/messages/sent" => "messages#sent"
    post "/messages/batch_delete" => "messages#batch_delete",
      :as => "batch_delete_messages"
    resources :messages do
      post "keep_as_new"
    end

    get "/s/:id/:title/comments/:comment_short_id" => "stories#show"
    get "/s/:id/(:title)" => "stories#show", :format => /html|json/

    get "/c/:id" => "comments#redirect_from_short_id"
    get "/c/:id.json" => "comments#show_short_id", :format => "json"

    get "/u" => "users#tree"
    get "/u/:username" => "users#show", :as => "user", :format => /html|json/

    post "/users/:username/ban" => "users#ban", :as => "user_ban"
    post "/users/:username/unban" => "users#unban", :as => "user_unban"
    post "/users/:username/disable_invitation" => "users#disable_invitation", :as => "user_disable_invite"
    post "/users/:username/enable_invitation" => "users#enable_invitation", :as => "user_enable_invite"

    get "/settings" => "settings#index"
    post "/settings" => "settings#update"
    post "/settings/pushover" => "settings#pushover"
    get "/settings/pushover_callback" => "settings#pushover_callback"
    post "/settings/delete_account" => "settings#delete_account",
      :as => "delete_account"

    get "/filters" => "filters#index"
    post "/filters" => "filters#update"

    get "/tags" => "tags#index"
    get "/tags.json" => "tags#index", :format => "json"

    post "/invitations" => "invitations#create"
    get "/invitations" => "invitations#index"
    get "/invitations/request" => "invitations#build"
    post "/invitations/create_by_request" => "invitations#create_by_request",
      :as => "create_invitation_by_request"
    get "/invitations/confirm/:code" => "invitations#confirm_email"
    post "/invitations/send_for_request" => "invitations#send_for_request",
      :as => "send_invitation_for_request"
    get "/invitations/:invitation_code" => "signup#invited"
    post "/invitations/delete_request" => "invitations#delete_request",
      :as => "delete_invitation_request"

    get "/hats" => "hats#index"
    get "/hats/build_request" => "hats#build_request",
      :as => "request_hat"
    post "/hats/create_request" => "hats#create_request",
      :as => "create_hat_request"
    get "/hats/requests" => "hats#requests_index"
    post "/hats/approve_request/:id" => "hats#approve_request",
      :as => "approve_hat_request"
    post "/hats/reject_request/:id" => "hats#reject_request",
      :as => "reject_hat_request"

    get "/moderations" => "moderations#index"
    get "/moderations/page/:page" => "moderations#index"

    get "/privacy" => "home#privacy"
    get "/about" => "home#about"
    get "/chat" => "home#chat"

    if defined?(BbsController) || Rails.env.development?
      get "/bbs" => "bbs#index"
    end

    get "/jobs/:job_id/applications/new_ref" => "applications#new_ref", :as => "new_job_application_ref"
    post "/jobs/:job_id/applications/by_ref" => "applications#create_ref", :as => "create_job_application_ref"

    resources :jobs do
      resources :applications do
        resources :collcomments, :only => [:create]
        resources :appl_questions, :except => [:edit, :show]
      end
      get "/applications/:id/referrer_details" => "applications#referrer_details", :as => "application_referrer"
    end

    get '/jobs/:job_id/applications/:application_id/appl_questions/:urlkey' => 'appl_questions#show', :as => "job_application_appl_question_show"

    get "/manage-jobs" => "jobs#manage_jobs", :as => "manage_jobs"
    get '/manage-jobs/page/:page' => 'jobs#manage_jobs'

    post '/jobs/:job_id/applications/:id/change_status/:status' => "applications#change_status", :as => "change_status_job_application"

    post '/jobs/:id/toggle_state' => "jobs#toggle_job", :as => "toggle_job"

    get "/u/jobs/:username" => "jobs#user_jobs", :as => "user_jobs"
    get "/u/applications/:username" => "jobs#user_applied_jobs", :as => "user_applications"
    get "/u/collaborations/:username" => "jobs#user_collab_jobs", :as => "user_collaborations"

    get "/u/jobs/:username/page/:page" => "jobs#user_jobs"
    get "/u/applications/:username/page/:page" => "jobs#user_applied_jobs"

    get '/jobs/page/:page' => 'jobs#index'

    get '/jobs/:id/add_collab' => "jobs#add_collaborator", :as => "add_collab"
    post '/jobs/:id/add_collab' => "jobs#add_collaborator_to_rel", :as => "add_collab_to_rel"

    get '/jobs/:id/collaborators' => "jobs#job_collabs_list", :as => "job_collabs"
    post '/jobs/:id/collaborators/:rem_id' => "jobs#remove_collab", :as => "rem_collab"

    get "/jobs/:job_id/applications/:id/page/:page" => "applications#show"

    get "/jobs/:job_id/applications/page/:page" => "applications#index"

    resources :organisations do
      resources :snippets, :except => [:show]
    end

    get '/organisations/:id/add_member' => "organisations#add_member", :as => "add_member"
    post '/organisations/:id/add_member' => "organisations#add_member_to_rel", :as => "add_member_to_rel"

    get '/organisations/:id/members' => "organisations#org_members_list", :as => "org_members"
    post '/organisations/:id/members/:rem_id' => "organisations#remove_member", :as => "rem_member"

    get "/organisations/:organisation_id/snippets/page/:page" => "snippets#index"

  end
end
