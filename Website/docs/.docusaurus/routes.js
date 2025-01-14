import React from 'react';
import ComponentCreator from '@docusaurus/ComponentCreator';

export default [
  {
    path: '/de/blog',
    component: ComponentCreator('/de/blog', 'f0f'),
    exact: true
  },
  {
    path: '/de/blog/archive',
    component: ComponentCreator('/de/blog/archive', '647'),
    exact: true
  },
  {
    path: '/de/blog/nitrification-process',
    component: ComponentCreator('/de/blog/nitrification-process', 'c12'),
    exact: true
  },
  {
    path: '/de/markdown-page',
    component: ComponentCreator('/de/markdown-page', 'de3'),
    exact: true
  },
  {
    path: '/de/docs',
    component: ComponentCreator('/de/docs', 'd5e'),
    routes: [
      {
        path: '/de/docs',
        component: ComponentCreator('/de/docs', '958'),
        routes: [
          {
            path: '/de/docs',
            component: ComponentCreator('/de/docs', 'c3f'),
            routes: [
              {
                path: '/de/docs/dev-docs/animal-detection/how_to_identify_any_fish',
                component: ComponentCreator('/de/docs/dev-docs/animal-detection/how_to_identify_any_fish', '39a'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/animal-disease-detection/how_to_check_animal_for_diseases',
                component: ComponentCreator('/de/docs/dev-docs/animal-disease-detection/how_to_check_animal_for_diseases', '5ea'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/environment-management/adding-an-environment',
                component: ComponentCreator('/de/docs/dev-docs/environment-management/adding-an-environment', '9f3'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/environment-management/delete-environment',
                component: ComponentCreator('/de/docs/dev-docs/environment-management/delete-environment', 'feb'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/environment-management/get-all-environments',
                component: ComponentCreator('/de/docs/dev-docs/environment-management/get-all-environments', '098'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/environment-management/get-public-environments',
                component: ComponentCreator('/de/docs/dev-docs/environment-management/get-public-environments', '4fe'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/environment-management/update-environment',
                component: ComponentCreator('/de/docs/dev-docs/environment-management/update-environment', '110'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/measurement-management/add_water_values',
                component: ComponentCreator('/de/docs/dev-docs/measurement-management/add_water_values', '8f8'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/measurement-management/export_water_values',
                component: ComponentCreator('/de/docs/dev-docs/measurement-management/export_water_values', '8c2'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/measurement-management/get_alert_settings',
                component: ComponentCreator('/de/docs/dev-docs/measurement-management/get_alert_settings', '8e9'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/measurement-management/get_all_values_from_parameter',
                component: ComponentCreator('/de/docs/dev-docs/measurement-management/get_all_values_from_parameter', 'bc9'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/measurement-management/get_latest_from_all_parameters',
                component: ComponentCreator('/de/docs/dev-docs/measurement-management/get_latest_from_all_parameters', '45f'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/measurement-management/get_total_entries',
                component: ComponentCreator('/de/docs/dev-docs/measurement-management/get_total_entries', 'fbe'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/measurement-management/import_water_values',
                component: ComponentCreator('/de/docs/dev-docs/measurement-management/import_water_values', 'b4f'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/measurement-management/save_alert_settings',
                component: ComponentCreator('/de/docs/dev-docs/measurement-management/save_alert_settings', '669'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/quick-start-guide',
                component: ComponentCreator('/de/docs/dev-docs/quick-start-guide', '132'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/user-management/create-an-account',
                component: ComponentCreator('/de/docs/dev-docs/user-management/create-an-account', '740'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/user-management/login',
                component: ComponentCreator('/de/docs/dev-docs/user-management/login', 'c73'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/dev-docs/user-management/profile',
                component: ComponentCreator('/de/docs/dev-docs/user-management/profile', '76a'),
                exact: true,
                sidebar: "devDocSidebar"
              },
              {
                path: '/de/docs/getting-started/adding-water-values',
                component: ComponentCreator('/de/docs/getting-started/adding-water-values', 'ca3'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/de/docs/getting-started/create-an-account',
                component: ComponentCreator('/de/docs/getting-started/create-an-account', 'e1d'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/de/docs/getting-started/create-new-environment',
                component: ComponentCreator('/de/docs/getting-started/create-new-environment', 'a90'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/de/docs/getting-started/explore-the-dashboard',
                component: ComponentCreator('/de/docs/getting-started/explore-the-dashboard', 'a25'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/de/docs/getting-started/thank-you',
                component: ComponentCreator('/de/docs/getting-started/thank-you', 'cba'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/de/docs/getting-started/use-the-app',
                component: ComponentCreator('/de/docs/getting-started/use-the-app', '15e'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              },
              {
                path: '/de/docs/getting-started/welcome',
                component: ComponentCreator('/de/docs/getting-started/welcome', 'f2b'),
                exact: true,
                sidebar: "gettingStartedSidebar"
              }
            ]
          }
        ]
      }
    ]
  },
  {
    path: '/de/',
    component: ComponentCreator('/de/', '4d1'),
    exact: true
  },
  {
    path: '*',
    component: ComponentCreator('*'),
  },
];
