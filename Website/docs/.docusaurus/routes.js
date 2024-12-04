import React from 'react';
import ComponentCreator from '@docusaurus/ComponentCreator';

export default [
  {
    path: '/de/blog',
    component: ComponentCreator('/de/blog', '668'),
    exact: true
  },
  {
    path: '/de/blog/archive',
    component: ComponentCreator('/de/blog/archive', '647'),
    exact: true
  },
  {
    path: '/de/blog/authors',
    component: ComponentCreator('/de/blog/authors', 'fd8'),
    exact: true
  },
  {
    path: '/de/blog/authors/all-sebastien-lorber-articles',
    component: ComponentCreator('/de/blog/authors/all-sebastien-lorber-articles', '5e5'),
    exact: true
  },
  {
    path: '/de/blog/authors/yangshun',
    component: ComponentCreator('/de/blog/authors/yangshun', '429'),
    exact: true
  },
  {
    path: '/de/blog/first-blog-post',
    component: ComponentCreator('/de/blog/first-blog-post', '04f'),
    exact: true
  },
  {
    path: '/de/blog/long-blog-post',
    component: ComponentCreator('/de/blog/long-blog-post', '0c8'),
    exact: true
  },
  {
    path: '/de/blog/mdx-blog-post',
    component: ComponentCreator('/de/blog/mdx-blog-post', '31f'),
    exact: true
  },
  {
    path: '/de/blog/tags',
    component: ComponentCreator('/de/blog/tags', '618'),
    exact: true
  },
  {
    path: '/de/blog/tags/docusaurus',
    component: ComponentCreator('/de/blog/tags/docusaurus', 'b35'),
    exact: true
  },
  {
    path: '/de/blog/tags/facebook',
    component: ComponentCreator('/de/blog/tags/facebook', '48f'),
    exact: true
  },
  {
    path: '/de/blog/tags/hello',
    component: ComponentCreator('/de/blog/tags/hello', 'd4b'),
    exact: true
  },
  {
    path: '/de/blog/tags/hola',
    component: ComponentCreator('/de/blog/tags/hola', '360'),
    exact: true
  },
  {
    path: '/de/blog/welcome',
    component: ComponentCreator('/de/blog/welcome', '9a6'),
    exact: true
  },
  {
    path: '/de/markdown-page',
    component: ComponentCreator('/de/markdown-page', 'de3'),
    exact: true
  },
  {
    path: '/de/docs',
    component: ComponentCreator('/de/docs', 'b44'),
    routes: [
      {
        path: '/de/docs',
        component: ComponentCreator('/de/docs', '8c6'),
        routes: [
          {
            path: '/de/docs',
            component: ComponentCreator('/de/docs', 'fb3'),
            routes: [
              {
                path: '/de/docs/category/animal-detection',
                component: ComponentCreator('/de/docs/category/animal-detection', '136'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/category/animal-disease-detection',
                component: ComponentCreator('/de/docs/category/animal-disease-detection', 'c87'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/category/environments',
                component: ComponentCreator('/de/docs/category/environments', '495'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/category/measurements',
                component: ComponentCreator('/de/docs/category/measurements', '793'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/category/user-management',
                component: ComponentCreator('/de/docs/category/user-management', 'e04'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/animal-detection/how_to_identify_any_fish',
                component: ComponentCreator('/de/docs/getting-started/animal-detection/how_to_identify_any_fish', '1e0'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/animal-disease-detection/how_to_check_animal_for_diseases',
                component: ComponentCreator('/de/docs/getting-started/animal-disease-detection/how_to_check_animal_for_diseases', 'c14'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/environment-management/adding-an-environment',
                component: ComponentCreator('/de/docs/getting-started/environment-management/adding-an-environment', '536'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/environment-management/delete-environment',
                component: ComponentCreator('/de/docs/getting-started/environment-management/delete-environment', 'cd3'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/environment-management/get-all-environments',
                component: ComponentCreator('/de/docs/getting-started/environment-management/get-all-environments', '314'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/environment-management/get-public-environments',
                component: ComponentCreator('/de/docs/getting-started/environment-management/get-public-environments', '0d3'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/environment-management/update-environment',
                component: ComponentCreator('/de/docs/getting-started/environment-management/update-environment', 'd95'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/measurement-management/add_water_values',
                component: ComponentCreator('/de/docs/getting-started/measurement-management/add_water_values', '51a'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/measurement-management/export_water_values',
                component: ComponentCreator('/de/docs/getting-started/measurement-management/export_water_values', '1fe'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/measurement-management/get_alert_settings',
                component: ComponentCreator('/de/docs/getting-started/measurement-management/get_alert_settings', 'c5b'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/measurement-management/get_all_values_from_parameter',
                component: ComponentCreator('/de/docs/getting-started/measurement-management/get_all_values_from_parameter', '99c'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/measurement-management/get_latest_from_all_parameters',
                component: ComponentCreator('/de/docs/getting-started/measurement-management/get_latest_from_all_parameters', '62c'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/measurement-management/get_total_entries',
                component: ComponentCreator('/de/docs/getting-started/measurement-management/get_total_entries', '8ae'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/measurement-management/import_water_values',
                component: ComponentCreator('/de/docs/getting-started/measurement-management/import_water_values', '095'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/measurement-management/save_alert_settings',
                component: ComponentCreator('/de/docs/getting-started/measurement-management/save_alert_settings', '890'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/quick-start-guide',
                component: ComponentCreator('/de/docs/getting-started/quick-start-guide', '0a9'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/user-management/create-an-account',
                component: ComponentCreator('/de/docs/getting-started/user-management/create-an-account', 'cee'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/user-management/jwt-tokens',
                component: ComponentCreator('/de/docs/getting-started/user-management/jwt-tokens', '48a'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/user-management/login',
                component: ComponentCreator('/de/docs/getting-started/user-management/login', 'cb1'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/getting-started/user-management/refresh-access-token',
                component: ComponentCreator('/de/docs/getting-started/user-management/refresh-access-token', '610'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/de/docs/real-world-example/Arduino',
                component: ComponentCreator('/de/docs/real-world-example/Arduino', '234'),
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
    path: '/de/',
    component: ComponentCreator('/de/', '4d1'),
    exact: true
  },
  {
    path: '*',
    component: ComponentCreator('*'),
  },
];
