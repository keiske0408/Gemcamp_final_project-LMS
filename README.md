# Lottery/Raffle Management System

## 📖 Overview

The Lottery/Raffle Management System is a full-featured platform designed for managing lotteries, raffles, and user interactions. It provides a streamlined interface for administrators and clients, supporting features like ticket purchases, prize claiming, and multi-language support (Tagalog and English). Built with Ruby on Rails, the application ensures scalability and user engagement through dynamic content and robust backend functionality.

## 🚀 Features

### General
* Secure user authentication using Devise.
* Role-based access for admins and clients.
* Multi-language support: Tagalog and English.

### For Clients
* Lottery Participation: Buy tickets for items/events.
* Prize Claiming: Claim prizes directly via profile.
* Feedback Sharing: Share experiences with messages and images.
* Shop Offers: Purchase offers to acquire coins.

### For Admins
* Manage users, orders, tickets, and prizes.
* Export data to CSV for reporting.
* Track and update the state of items, tickets, and winners.
* Set dynamic banners and news tickers.

### System Features
* State Management with AASM for tickets, items, and winners.
* Soft Deletion for items and categories.
* Dynamic sorting and filtering for admin and client views

## 🛠️ Tech Stack
* Backend: Ruby on Rails
* Frontend: Bootstrap for responsive design
* Database: PostgreSQL/MariaDB
* Authentication: Devise
* Gems:
    * AASM for state management
    * rqrcode for QR code generation
    * carrierwave for image uploads
  


