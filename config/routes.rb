Rails.application.routes.draw do
  
  root to: 'auth#login'
  post  'login',  to: 'auth#login_do', as: 'login'
  match 'logout', to: 'auth#logout', via: [:get, :post], as: 'logout'


  get 'app/setup',        to: 'nexmo_app#setup',        as: 'app_setup'
  post 'app/create',      to: 'nexmo_app#create',       as: 'app_create'
  post 'app/use/:id',      to: 'nexmo_app#reuse',       as: 'app_reuse'
  get 'app/reset',        to: 'nexmo_app#reset',        as: 'app_reset'
  get  'app',             to: 'nexmo_app#show',         as: 'app'
  post 'app/regenerate_keys', to: 'nexmo_app#regenerate_keys',       as: 'app_regenerate_keys'
  get  'app/private_key', to: 'nexmo_app#private_key',  as: 'app_private_key'
  get  'app/public_key',  to: 'nexmo_app#public_key',   as: 'app_public_key'


  get 'messages/sms'
  get 'messages/mms'
  get 'messages/whatsapp'
  get 'messages/messenger'
  get 'messages/viber'


  get  'dispatch',                        to: 'dispatch#index',    as: 'dispatch'
  

  get  'numbers',                         to: 'numbers#index',    as: 'numbers'
  get  'numbers/search',                  to: 'numbers#search',   as: 'numbers_search_get'
  post 'numbers/search',                  to: 'numbers#search',   as: 'numbers_search'
  post 'numbers/buy',                     to: 'numbers#buy',      as: 'numbers_buy'
  post 'numbers/add/:country/:msisdn',    to: 'numbers#add',      as: 'numbers_add'
  post 'numbers/remove/:country/:msisdn', to: 'numbers#remove',   as: 'numbers_remove'


  get  'external_accounts',               to: 'external_accounts#index',    as: 'external_accounts'
  post 'external_accounts/add',           to: 'external_accounts#add',   as: 'external_accounts_add'
  post 'external_accounts/remove/:provider/:external_id', to: 'external_accounts#remove',   as: 'external_accounts_remove'


  get 'events',       to: 'events#index',   as: 'events'
  get 'events/raw',   to: 'events#raw',     as: 'events_raw'


  post  'webhooks/:app_id/inbound', to: 'webhooks#inbound',    as: 'webhooks_inbound'
  post 'webhooks/:app_id/status',  to: 'webhooks#status',     as: 'webhooks_status'

  
end
