
import { INavData } from '@coreui/angular';

export const navItems: INavData[] = [
  {
    name: 'Dashboard',
    url: '/dashboard',
    iconComponent: { name: 'cil-speedometer' }
  },
  {
    name: 'Music Genres',
    url: '/categories',
    iconComponent: { name: 'cil-grid' }
  },
  // {
  //   name: 'Generes DJ',
  //   url: '/product-category',
  //   iconComponent: { name: 'cil-grid' }
  // },
  {
    name: 'Cities',
    url: '/cities',
    iconComponent: { name: 'cil-location-pin' }
  },
  {
    name: 'Banners',
    url: '/banners',
    iconComponent: { name: 'cil-spreadsheet' }
  },
  {
    name: 'Djs',
    url: '/salons',
    iconComponent: { name: 'cib-deezer' },
    children: [
      {
        name: 'Djs',
        url: '/salons',
        iconComponent: { name: 'cib-deezer' }
      },
      {
        name: 'Djs Events',
        url: '/appointments',
        iconComponent: { name: 'cil-calendar' },
      },
      {
        name: 'Joining Request',
        url: '/salon-request',
        iconComponent: { name: 'cil-face' }
      },
      {
        name: 'Djs Stats',
        url: '/salon-stats',
        iconComponent: { name: 'cil-chart-line' }
      }
    ]
  },
  {
    name: 'Artists',
    url: '/freelancer',
    iconComponent: { name: 'cil-walk' },
    children: [
      {
        name: 'Artists',
        url: '/freelancer',
        iconComponent: { name: 'cil-walk' },
      },
      {
        name: 'Artists Events',
        url: '/freelancer-appointments',
        iconComponent: { name: 'cil-calendar' },
      },
      {
        name: 'Joining Request',
        url: '/freelancer-request',
        iconComponent: { name: 'cil-face' }
      },
      {
        name: 'Artists Stats',
        url: '/freelancer-stats',
        iconComponent: { name: 'cil-chart-line' }
      }
    ]
  },
  // {
  //   name: 'Shop',
  //   url: '/product-category',
  //   iconComponent: { name: 'cil-puzzle' },
  //   children: [
  //     {
  //       name: 'Categories',
  //       url: '/product-category',
  //       iconComponent: { name: 'cil-notes' }
  //     },
  //     {
  //       name: 'Sub Categories',
  //       url: '/product-sub-category',
  //       iconComponent: { name: 'cil-clear-all' }
  //     },
  //     {
  //       name: 'Products',
  //       url: '/products',
  //       iconComponent: { name: 'cil-paint' }
  //     },
  //     {
  //       name: 'Orders',
  //       url: '/orders',
  //       iconComponent: { name: 'cil-cart' },
  //     },
  //     {
  //       name: 'Orders Stats',
  //       url: '/product-stats',
  //       iconComponent: { name: 'cil-chart-line' }
  //     }
  //   ]
  // },
  {
    name: 'Venues',
    url: '/users',
    iconComponent: { name: 'cil-user' }
  },
  // {
  //   name: 'Offers',
  //   url: '/offers',
  //   iconComponent: { name: 'cil-link' }
  // },
  {
    name: 'App Pages',
    url: '/app-pages',
    iconComponent: { name: 'cil-description' }
  },
  {
    name: 'Blogs',
    url: '/blogs',
    iconComponent: { name: 'cil-inbox' }
  },
  // {
  //   name: 'Referral',
  //   url: '/referral',
  //   iconComponent: { name: 'cil-tags' }
  // },
  // {
  //   name: 'Supports',
  //   url: '/supports',
  //   iconComponent: { name: 'cil-info' }
  // },
  // {
  //   name: 'Complaints',
  //   url: '/complaints',
  //   iconComponent: { name: 'cil-volume-high' }
  // },
  // {
  //   name: 'Payments',
  //   url: '/payments',
  //   iconComponent: { name: 'cil-credit-card' }
  // },
  // {
  //   name: 'Address',
  //   url: '/address',
  //   iconComponent: { name: 'cil-location-pin' }
  // },
  {
    name: 'Supports',
    url: '/contact-forms',
    iconComponent: { name: 'cil-address-book' }
  },
  {
    name: 'Administrator',
    url: '/administrator',
    iconComponent: { name: 'cil-line-weight' }
  },
  {
    name: 'Notifications',
    url: '/notifications',
    iconComponent: { name: 'cil-bell-exclamation' }
  },
  {
    name: 'Send Mail',
    url: '/send-mail',
    iconComponent: { name: 'cil-address-book' }
  },
  {
    name: 'Settings',
    url: '/settings',
    iconComponent: { name: 'cil-settings' }
  },
];
