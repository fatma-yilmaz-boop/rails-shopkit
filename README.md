# 💎 rails-shopkit

A modular, open-source e-commerce engine for Ruby on Rails with multi-tenant support, payment integrations, and inventory management.

[![Gem](https://img.shields.io/badge/gem-v1.4.0-red)](https://rubygems.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Ruby 3.2+](https://img.shields.io/badge/Ruby-3.2+-CC342D.svg)](https://ruby-lang.org)

## Features

- 🏪 **Multi-tenant** — Run multiple stores from a single Rails app
- 💳 **Payments** — Stripe, PayPal, and iyzico integrations
- 📦 **Inventory** — Stock tracking, variants, and warehouse management
- 🔌 **Modular** — Mount as an engine or use individual components
- 🌍 **I18n** — Multi-language and multi-currency support

## Quick Start

```ruby
# Gemfile
gem 'rails-shopkit', '~> 1.4'
```

```bash
rails generate shopkit:install
rails db:migrate
```

```ruby
# config/routes.rb
Rails.application.routes.draw do
  mount Shopkit::Engine => '/shop'
end
```

## Models

```ruby
# Create a product with variants
product = Shopkit::Product.create!(
  title: "Premium T-Shirt",
  description: "100% organic cotton",
  price: Money.new(2999, "USD"),
  status: :active
)

product.variants.create!([
  { option: "Size: S", sku: "TS-S-001", stock: 50 },
  { option: "Size: M", sku: "TS-M-001", stock: 120 },
  { option: "Size: L", sku: "TS-L-001", stock: 80 },
])

# Process an order
cart = Shopkit::Cart.new(customer: current_user)
cart.add_item(product.variants.first, quantity: 2)

order = cart.checkout!(
  payment_method: :stripe,
  shipping_address: address_params
)
```

## Architecture

```
rails-shopkit/
├── app/
│   ├── models/shopkit/     # Product, Order, Cart, Variant
│   ├── controllers/        # Storefront & Admin controllers
│   ├── views/              # ERB templates with Hotwire
│   └── jobs/               # Background order processing
├── lib/
│   ├── shopkit/
│   │   ├── payments/       # Payment gateway adapters
│   │   ├── shipping/       # Shipping rate calculators
│   │   └── tax/            # Tax calculation engines
└── config/
    └── locales/            # I18n translations
```

## License

MIT License
