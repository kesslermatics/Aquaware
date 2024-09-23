import React from 'react';
import ComponentCreator from '@docusaurus/ComponentCreator';

export default [
  {
    path: '/blog',
    component: ComponentCreator('/blog', 'b2f'),
    exact: true
  },
  {
    path: '/blog/archive',
    component: ComponentCreator('/blog/archive', '182'),
    exact: true
  },
  {
    path: '/blog/authors',
    component: ComponentCreator('/blog/authors', '0b7'),
    exact: true
  },
  {
    path: '/blog/authors/all-sebastien-lorber-articles',
    component: ComponentCreator('/blog/authors/all-sebastien-lorber-articles', '4a1'),
    exact: true
  },
  {
    path: '/blog/authors/yangshun',
    component: ComponentCreator('/blog/authors/yangshun', 'a68'),
    exact: true
  },
  {
    path: '/blog/first-blog-post',
    component: ComponentCreator('/blog/first-blog-post', '89a'),
    exact: true
  },
  {
    path: '/blog/long-blog-post',
    component: ComponentCreator('/blog/long-blog-post', '9ad'),
    exact: true
  },
  {
    path: '/blog/mdx-blog-post',
    component: ComponentCreator('/blog/mdx-blog-post', 'e9f'),
    exact: true
  },
  {
    path: '/blog/tags',
    component: ComponentCreator('/blog/tags', '287'),
    exact: true
  },
  {
    path: '/blog/tags/docusaurus',
    component: ComponentCreator('/blog/tags/docusaurus', '704'),
    exact: true
  },
  {
    path: '/blog/tags/facebook',
    component: ComponentCreator('/blog/tags/facebook', '858'),
    exact: true
  },
  {
    path: '/blog/tags/hello',
    component: ComponentCreator('/blog/tags/hello', '299'),
    exact: true
  },
  {
    path: '/blog/tags/hola',
    component: ComponentCreator('/blog/tags/hola', '00d'),
    exact: true
  },
  {
    path: '/blog/welcome',
    component: ComponentCreator('/blog/welcome', 'd2b'),
    exact: true
  },
  {
    path: '/markdown-page',
    component: ComponentCreator('/markdown-page', '3d7'),
    exact: true
  },
  {
    path: '/docs',
    component: ComponentCreator('/docs', '4ce'),
    routes: [
      {
        path: '/docs',
        component: ComponentCreator('/docs', '952'),
        routes: [
          {
            path: '/docs',
            component: ComponentCreator('/docs', 'fb9'),
            routes: [
              {
                path: '/docs/category/environments',
                component: ComponentCreator('/docs/category/environments', 'e65'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/category/measurements',
                component: ComponentCreator('/docs/category/measurements', '42a'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/category/user-management',
                component: ComponentCreator('/docs/category/user-management', '395'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/environment-management/adding-an-environment',
                component: ComponentCreator('/docs/environment-management/adding-an-environment', 'f9f'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/environment-management/delete-environment',
                component: ComponentCreator('/docs/environment-management/delete-environment', '963'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/environment-management/get-all-environments',
                component: ComponentCreator('/docs/environment-management/get-all-environments', '64e'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/environment-management/get-public-environments',
                component: ComponentCreator('/docs/environment-management/get-public-environments', '7d6'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/environment-management/update-environment',
                component: ComponentCreator('/docs/environment-management/update-environment', '3d1'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/measurement-management/add_water_values',
                component: ComponentCreator('/docs/measurement-management/add_water_values', '186'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/measurement-management/export_water_values',
                component: ComponentCreator('/docs/measurement-management/export_water_values', '8dc'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/measurement-management/get_alert_settings',
                component: ComponentCreator('/docs/measurement-management/get_alert_settings', '6ab'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/measurement-management/get_all_values_from_parameter',
                component: ComponentCreator('/docs/measurement-management/get_all_values_from_parameter', 'd7a'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/measurement-management/get_latest_from_all_parameters',
                component: ComponentCreator('/docs/measurement-management/get_latest_from_all_parameters', 'f00'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/measurement-management/get_total_entries',
                component: ComponentCreator('/docs/measurement-management/get_total_entries', '471'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/measurement-management/import_water_values',
                component: ComponentCreator('/docs/measurement-management/import_water_values', 'b31'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/measurement-management/save_alert_settings',
                component: ComponentCreator('/docs/measurement-management/save_alert_settings', '44c'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/quick-start-guide',
                component: ComponentCreator('/docs/quick-start-guide', '431'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/user-management/create-an-account',
                component: ComponentCreator('/docs/user-management/create-an-account', 'd2e'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/user-management/jwt-tokens',
                component: ComponentCreator('/docs/user-management/jwt-tokens', 'e81'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/docs/user-management/login',
                component: ComponentCreator('/docs/user-management/login', '96b'),
                exact: true,
                sidebar: "tutorialSidebar"
              }
            ]
          }
        ]
      }
    ]
  },
  {
    path: '/',
    component: ComponentCreator('/', '2e1'),
    exact: true
  },
  {
    path: '*',
    component: ComponentCreator('*'),
  },
];
