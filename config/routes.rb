Rails.application.routes.draw do |map|
  resources :coupons do
    collection do
      get 'test'
      get 'apply'
      get 'redeem'
    end
  end
end