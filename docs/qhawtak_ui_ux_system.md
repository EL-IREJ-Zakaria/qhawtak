# Qhawtak UI/UX System

## 1) Product Vision
Qhawtak is a table-side coffee ordering platform:
- Customers use a web interface to choose table, browse drinks, and place orders.
- Cafe owners use a mobile admin app to receive and manage orders in real time.

Design direction: modern cafe aesthetic, warm tones, clean hierarchy, rounded cards, and fast one-hand mobile interaction.

## 2) Brand Foundation

### Brand Personality
- Warm
- Reliable
- Minimal
- Crafted

### Logo Concept (Q + Cup + Steam)
- Shape: circular outline forming the letter `Q`
- Cup: lower bowl of the `Q`
- Steam: one to two curved lines that also imply the `Q` tail
- Style: monoline icon with rounded endpoints
- Pairing: icon + wordmark `Qhawtak`

### Logo Usage Rules
- Minimum clear space: `0.5x` icon width on all sides
- Minimum size:
  - Web header: `24px` icon
  - App splash: `96px` icon
- Preferred lockup: icon left, wordmark right
- Do not stretch, rotate, or add strong gradients

## 3) Design Tokens

### Color Palette
- `primary` (Dark Coffee Brown): `#4E342E`
- `secondary` (Warm Brown): `#6D4C41`
- `accent` (Caramel): `#C68B59`
- `background` (Latte Cream): `#F5E9DA`
- `surface`: `#FFFFFF`
- `text-primary`: `#2D1F1B`
- `text-secondary`: `#6B5A55`
- `success`: `#2E7D32`
- `warning`: `#ED6C02`
- `error`: `#C62828`
- `info`: `#1565C0`
- `border`: `#E7D8C6`

### Elevation
- `elevation-1`: `0 2 8 rgba(78, 52, 46, 0.08)`
- `elevation-2`: `0 6 16 rgba(78, 52, 46, 0.12)`
- `elevation-3`: `0 10 24 rgba(78, 52, 46, 0.16)`

### Radius
- `r-sm`: `10px`
- `r-md`: `14px`
- `r-lg`: `18px`
- `r-pill`: `999px`

### Spacing Scale
- `4, 8, 12, 16, 20, 24, 32, 40`

### Typography
Primary font family (choose one and keep consistent across both products):
- `Poppins` (recommended)
- `Inter`
- `Montserrat`

Type scale:
- `display`: 32 / 700
- `h1`: 28 / 700
- `h2`: 22 / 600
- `h3`: 18 / 600
- `body-lg`: 16 / 500
- `body`: 14 / 400
- `caption`: 12 / 400
- `button`: 15 / 600

### Motion
- Base duration: `180ms`
- Enter: `220ms` ease-out
- Exit: `140ms` ease-in
- List stagger: `40ms`
- Avoid excessive bouncing; focus on calm transitions

## 4) Information Architecture

### Customer Web
1. Landing
2. Select Table
3. Menu (listing)
4. Coffee Detail
5. Cart
6. Checkout
7. Confirmation

### Admin Mobile
1. Splash
2. Login
3. Dashboard (live orders)
4. Order Details / Status updates
5. Menu Management
6. Add/Edit Coffee
7. Sales Statistics
8. Notifications Center

## 5) Customer Web UX Specifications

### 5.1 Landing Page
Purpose: quick entry with brand trust.

Layout:
- Top: logo + cafe name
- Hero card with short message: "Order your coffee in seconds"
- CTA button: `Start Order`

Components:
- Primary button (full width on mobile)
- Decorative coffee background pattern (very subtle, 3-5% opacity)

States:
- Loading skeleton for hero assets
- Offline banner if network unavailable

### 5.2 Select Table Number
Purpose: bind order to physical table.

Layout:
- Title + helper text
- Grid of table chips (e.g., 1-30)
- Manual input fallback
- Sticky bottom CTA: `Continue`

Interaction:
- Single selection only
- Persist selected table in session storage

Validation:
- Disable CTA until valid table selected
- Error copy: "Please select your table to continue"

### 5.3 Coffee Menu Page
Purpose: discover and choose items quickly.

Layout:
- Header: selected table + cart icon badge
- Search field
- Category tabs: `Hot`, `Cold`, `Popular`
- Product card grid/list

Product card content:
- Coffee image
- Name
- Short note
- Price
- `View` and quick `+` add action

Interaction:
- Fast add increases cart count with toast feedback
- Tap card opens detail page

### 5.4 Coffee Detail Page
Purpose: informed purchase decision.

Layout:
- Large image
- Name, rating (optional), price
- Description
- Customization section (size, sugar level, extra shot)
- Quantity stepper
- Sticky CTA: `Add to Cart`

### 5.5 Add to Cart
Behavior:
- Add from menu card or detail
- Merge same item + same options
- New line item if options differ

Feedback:
- Success toast: "Added to cart"
- Cart badge animates subtly

### 5.6 Cart Page
Layout:
- List of cart items (image thumb, name, options, qty controls, line total)
- Price summary:
  - Subtotal
  - Service fee (optional)
  - Grand total
- CTA: `Proceed to Checkout`

Rules:
- Prevent quantity below 1
- Swipe-to-remove on mobile

### 5.7 Checkout Page
Layout:
- Section: table number (editable)
- Section: order items summary
- Optional notes field ("No sugar", "Extra hot")
- Payment method label (`Pay at Counter` or integrated payment later)
- CTA: `Place Order`

Post action:
- Create order request
- Show progress state while awaiting response

### 5.8 Order Confirmation Page
Layout:
- Success icon
- Order number
- Table number
- ETA label (example: 8-12 minutes)
- Ordered items summary
- CTA: `Back to Menu`

Optional:
- Live order tracker chips: `Accepted > Preparing > Ready > Completed`

## 6) Admin Mobile UX Specifications (Flutter)

### 6.1 Splash Screen
- Centered Qhawtak logo
- Warm gradient backdrop from `#F5E9DA` to `#EED9C1`
- Auto route after auth token check

### 6.2 Admin Login
Fields:
- Email / username
- Password
- Sign in button

Support:
- Forgot password
- Inline validation messages
- Biometric quick login (future)

### 6.3 Dashboard (Live Incoming Orders)
Primary screen with segmented tabs:
- `New`
- `Preparing`
- `Ready`
- `Completed`

Header:
- Cafe name
- Active orders count
- Notification bell with unread badge

Order list:
- Card stack sorted by latest timestamp
- Pull-to-refresh + websocket real-time updates

### 6.4 Order Card Design
Card fields (required):
- Table number
- Coffee name
- Quantity
- Unit price
- Total price
- Order time

Card extras (recommended):
- Order ID
- Notes
- Time elapsed badge (e.g., `+6 min`)

Card actions by status:
- New -> `Accept`
- Accepted -> `Preparing`
- Preparing -> `Ready`
- Ready -> `Completed`

### 6.5 Order Lifecycle Logic
Statuses:
1. `new`
2. `accepted`
3. `preparing`
4. `ready`
5. `completed`
6. `cancelled` (admin-only edge case)

UX behavior:
- Optimistic UI update on action tap
- Rollback + snackbar on API failure
- Confirmation dialog only for `cancelled` and `completed`

### 6.6 Coffee Menu Management
Screen sections:
- Coffee list with search/filter
- Floating action button: `Add Coffee`

Coffee row actions:
- Edit
- Delete (with confirm modal)
- Toggle availability (`In stock` / `Out of stock`)

### 6.7 Add/Edit Coffee Screen
Fields:
- Name
- Description
- Price
- Category (Hot/Cold/Special)
- Image upload
- Availability toggle

Validation:
- Name required
- Price numeric and > 0
- Image optional but recommended

### 6.8 Sales Statistics Screen
Time filters:
- Today
- This week
- This month
- Custom range

Widgets:
- KPI cards: total sales, orders count, average order value
- Top coffees list
- Hourly sales chart

### 6.9 Notifications
Events:
- New order placed
- Order cancelled
- System warning (connectivity)

Design:
- In-app notification center list
- Push notification deep links to order detail

## 7) Shared Component System

### Core Components
- App bar
- Primary/secondary buttons
- Text fields
- Tabs/chips
- Product card
- Order card
- Status badge
- Toast/snackbar
- Dialog / bottom sheet
- Empty state panel
- Skeleton loaders

### Button Variants
- `Primary`: filled `#4E342E`, white text
- `Secondary`: outline `#6D4C41`
- `Accent`: filled `#C68B59`, dark text
- `Danger`: red for destructive actions

### Status Badge Colors
- `new`: blue tone
- `accepted`: warm brown
- `preparing`: amber
- `ready`: green
- `completed`: neutral brown/gray
- `cancelled`: red

## 8) Responsive Behavior (Web)

Breakpoints:
- `xs`: < 480px
- `sm`: 480-767px
- `md`: 768-1023px
- `lg`: >= 1024px

Layout rules:
- Mobile first
- Sticky bottom CTAs on mobile
- 1-column cards on mobile, 2-3 columns on tablet/desktop
- Max content width: `1200px`

## 9) Accessibility Guidelines
- Contrast ratio at least 4.5:1 for body text
- Touch targets minimum 44x44 px
- Semantic headings and landmarks on web
- Screen-reader labels for icon buttons
- Visible focus ring for keyboard navigation
- Do not rely on color alone for status; pair with text/icon

## 10) Real-Time and API-Ready UX Contracts

### Suggested Endpoints
Customer web:
- `GET /menu`
- `GET /menu/:id`
- `POST /orders`
- `GET /orders/:id`

Admin app:
- `POST /admin/login`
- `GET /admin/orders?status=new`
- `PATCH /admin/orders/:id/status`
- `GET /admin/menu`
- `POST /admin/menu`
- `PUT /admin/menu/:id`
- `DELETE /admin/menu/:id`
- `GET /admin/stats?range=today`

Real-time events (WebSocket/SSE):
- `order.created`
- `order.status.updated`
- `menu.updated`

### Shared Data Models
Order:
- `id`
- `tableNumber`
- `items[]` { `coffeeId`, `name`, `qty`, `unitPrice`, `lineTotal`, `options` }
- `subtotal`
- `total`
- `status`
- `notes`
- `createdAt`
- `updatedAt`

Coffee:
- `id`
- `name`
- `description`
- `price`
- `category`
- `imageUrl`
- `isAvailable`

## 11) Copy Guidelines (Microcopy)
- Friendly and concise
- Action-first button labels (`Place Order`, `Mark Ready`)
- Human confirmations:
  - "Order received. We are brewing it now."
  - "Marked as ready for table 7."

## 12) Error/Empty/Loading States

Customer examples:
- Empty cart: "Your cart is empty. Let's pick your coffee."
- API error: "We couldn't place your order. Please try again."

Admin examples:
- No new orders: "No new orders right now."
- Sync lost: persistent top banner + retry action

Loading:
- Skeleton cards for menu and orders
- Disable buttons while submit in progress

## 13) Implementation Blueprint

### Flutter Admin App Structure
`lib/`
- `core/theme/` (colors, typography, spacing, component themes)
- `features/auth/`
- `features/orders/`
- `features/menu/`
- `features/stats/`
- `features/notifications/`
- `shared/widgets/`
- `shared/models/`
- `shared/services/api_client.dart`
- `shared/services/realtime_service.dart`

Recommended state approach:
- `Riverpod` or `Bloc`

### Web Customer Interface (Modern Stack)
Recommended options:
- React + Next.js
- Vue + Nuxt
- Flutter Web (if single-stack preference)

Web front-end folders:
- `design-tokens/`
- `components/`
- `pages/`
- `services/api.ts`
- `stores/cart.ts`

## 14) Design QA Checklist
- All screens use tokenized colors/spacing/radius
- Status colors and labels are consistent across web and app
- Real-time order updates visible in <= 2 seconds
- Core customer flow completed in <= 60 seconds (table select to order place)
- Admin can update order status in <= 2 taps from dashboard
- Accessibility checks pass for contrast and touch targets

## 15) Suggested Next Implementation Steps
1. Build shared design tokens in code (Flutter theme + CSS variables).
2. Implement customer web flow from Landing -> Confirmation with mocked API.
3. Implement admin order dashboard with websocket mock stream.
4. Connect both clients to backend API.
5. Add push notifications and sales analytics.
