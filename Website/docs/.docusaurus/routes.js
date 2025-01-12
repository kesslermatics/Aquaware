import React from 'react';
import ComponentCreator from '@docusaurus/ComponentCreator';

export default [
  {
    path: '/__docusaurus/debug',
    component: ComponentCreator('/__docusaurus/debug', '5ff'),
    exact: true
  },
  {
    path: '/__docusaurus/debug/config',
    component: ComponentCreator('/__docusaurus/debug/config', '5ba'),
    exact: true
  },
  {
    path: '/__docusaurus/debug/content',
    component: ComponentCreator('/__docusaurus/debug/content', 'a2b'),
    exact: true
  },
  {
    path: '/__docusaurus/debug/globalData',
    component: ComponentCreator('/__docusaurus/debug/globalData', 'c3c'),
    exact: true
  },
  {
    path: '/__docusaurus/debug/metadata',
    component: ComponentCreator('/__docusaurus/debug/metadata', '156'),
    exact: true
  },
  {
    path: '/__docusaurus/debug/registry',
    component: ComponentCreator('/__docusaurus/debug/registry', '88c'),
    exact: true
  },
  {
    path: '/__docusaurus/debug/routes',
    component: ComponentCreator('/__docusaurus/debug/routes', '000'),
    exact: true
  },
  {
    path: '/blog',
    component: ComponentCreator('/blog', '50a'),
    exact: true
  },
  {
    path: '/blog/archive',
    component: ComponentCreator('/blog/archive', '182'),
    exact: true
  },
  {
    path: '/blog/nitrification-process',
    component: ComponentCreator('/blog/nitrification-process', 'bcb'),
    exact: true
  },
  {
    path: '/markdown-page',
    component: ComponentCreator('/markdown-page', '3d7'),
    exact: true
  },
  {
    path: '/docs',
    component: ComponentCreator('/docs', '224'),
    routes: [
      {
        path: '/docs',
        component: ComponentCreator('/docs', '3a8'),
        routes: [
          {
            path: '/docs',
            component: ComponentCreator('/docs', '9b6'),
            routes: [
              {
                path: '/docs/dev-docs/animal-detection/how_to_identify_any_fish',
                component: ComponentCreator('/docs/dev-docs/animal-detection/how_to_identify_any_fish', 'fae'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/dev-docs/animal-disease-detection/how_to_check_animal_for_diseases',
                component: ComponentCreator('/docs/dev-docs/animal-disease-detection/how_to_check_animal_for_diseases', '2e4'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/dev-docs/environment-management/adding-an-environment',
                component: ComponentCreator('/docs/dev-docs/environment-management/adding-an-environment', '5b8'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/dev-docs/environment-management/delete-environment',
                component: ComponentCreator('/docs/dev-docs/environment-management/delete-environment', 'be1'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/dev-docs/environment-management/get-all-environments',
                component: ComponentCreator('/docs/dev-docs/environment-management/get-all-environments', 'b6b'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/dev-docs/environment-management/get-public-environments',
                component: ComponentCreator('/docs/dev-docs/environment-management/get-public-environments', 'ee5'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/dev-docs/environment-management/update-environment',
                component: ComponentCreator('/docs/dev-docs/environment-management/update-environment', 'd44'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/dev-docs/measurement-management/add_water_values',
                component: ComponentCreator('/docs/dev-docs/measurement-management/add_water_values', '604'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/dev-docs/measurement-management/export_water_values',
                component: ComponentCreator('/docs/dev-docs/measurement-management/export_water_values', 'dc0'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/dev-docs/measurement-management/get_alert_settings',
                component: ComponentCreator('/docs/dev-docs/measurement-management/get_alert_settings', '710'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/dev-docs/measurement-management/get_all_values_from_parameter',
                component: ComponentCreator('/docs/dev-docs/measurement-management/get_all_values_from_parameter', 'b08'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/dev-docs/measurement-management/get_latest_from_all_parameters',
                component: ComponentCreator('/docs/dev-docs/measurement-management/get_latest_from_all_parameters', '901'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/dev-docs/measurement-management/get_total_entries',
                component: ComponentCreator('/docs/dev-docs/measurement-management/get_total_entries', '284'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/dev-docs/measurement-management/import_water_values',
                component: ComponentCreator('/docs/dev-docs/measurement-management/import_water_values', 'ac3'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/dev-docs/measurement-management/save_alert_settings',
                component: ComponentCreator('/docs/dev-docs/measurement-management/save_alert_settings', '306'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/dev-docs/quick-start-guide',
                component: ComponentCreator('/docs/dev-docs/quick-start-guide', 'c14'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/dev-docs/user-management/create-an-account',
                component: ComponentCreator('/docs/dev-docs/user-management/create-an-account', '804'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/dev-docs/user-management/jwt-tokens',
                component: ComponentCreator('/docs/dev-docs/user-management/jwt-tokens', '57c'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/dev-docs/user-management/login',
                component: ComponentCreator('/docs/dev-docs/user-management/login', 'ee0'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/dev-docs/user-management/refresh-access-token',
                component: ComponentCreator('/docs/dev-docs/user-management/refresh-access-token', '5b1'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/docs/getting-started/adding-water-values',
                component: ComponentCreator('/docs/getting-started/adding-water-values', '4a6'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/docs/getting-started/create-an-account',
                component: ComponentCreator('/docs/getting-started/create-an-account', '4be'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/docs/getting-started/create-new-environment',
                component: ComponentCreator('/docs/getting-started/create-new-environment', '8fc'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/docs/getting-started/explore-the-dashboard',
                component: ComponentCreator('/docs/getting-started/explore-the-dashboard', 'db9'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/docs/getting-started/thank-you',
                component: ComponentCreator('/docs/getting-started/thank-you', '6d5'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/docs/getting-started/use-the-app',
                component: ComponentCreator('/docs/getting-started/use-the-app', '869'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/docs/getting-started/welcome',
                component: ComponentCreator('/docs/getting-started/welcome', 'c89'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/docs/real-world-example/Arduino',
                component: ComponentCreator('/docs/real-world-example/Arduino', 'd1d'),
                exact: true,
                sidebar: "realWorldSidebar"
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
