import { faTv } from "@fortawesome/free-solid-svg-icons";
import { faCode } from "@fortawesome/free-solid-svg-icons";
import { faChartLine } from "@fortawesome/free-solid-svg-icons";
import { faRobot } from "@fortawesome/free-solid-svg-icons";
import { faWater } from "@fortawesome/free-solid-svg-icons";
import { faBookOpen } from "@fortawesome/free-solid-svg-icons";

import {
  benefitImage2,
  file02,
  homeSmile,
  plusSquare,
  searchMd,
  yourlogo,
} from "../../src/assets";

export const navigation = [
  {
    id: "0",
    title: "Features",
    url: "/#features",
  },
  {
    id: "1",
    title: "How it works",
    url: "/#how-to-use",
  },
  {
    id: "2",
    title: "Api-Documentation",
    url: "/docs/index.html",
  },
  {
    id: "3",
    title: "Pricing",
    url: "/#pricing",
  },
  {
    id: "4",
    title: "Create Account",
    url: "/signup",
    onlyMobile: true,
  },
  {
    id: "5",
    title: "Login",
    url: "/login",
    onlyMobile: true,
  },
];

export const heroIcons = [homeSmile, file02, searchMd, plusSquare];

export const companyLogos = [yourlogo, yourlogo, yourlogo, yourlogo, yourlogo];

export const pricing = [
  {
    id: "0",
    title: "Hobby",
    description:
      "Free for personal use, monitor all water parameters with limited uploads",
    price: "0",
    features: [
      "Monitor all water parameters (e.g., pH, temperature, salinity, etc.)",
      "Upload water values every 2 hours to conserve resources",
      "Basic water quality tracking",
      "Access to real-time data visualization",
      "Community support",
    ],
  },
  {
    id: "1",
    title: "Advanced",
    description: "AI-powered insights and advanced monitoring tools",
    price: "7.99",
    features: [
      "Monitor all water parameters with no limits",
      "AI-powered insights for water trend analysis and predictions",
      "Advanced data visualizations and custom dashboards",
      "Add alerts and notifications for specific water parameter thresholds",
      "Ideal for users wanting advanced analysis and data-driven decisions",
    ],
  },
  {
    id: "2",
    title: "Business",
    description:
      "Frequent water monitoring with priority features for businesses",
    price: "15.99",
    features: [
      "Monitor all water parameters with no limits",
      "Upload water values every 30 minutes for precise tracking",
      "Add public water bodies for public data sharing",
      "Priority customer support",
      "Perfect for businesses needing detailed water insights with high accuracy",
      "AI tools included",
    ],
  },
];

export const benefits = [
  {
    id: "0",
    title: "Monitor Your Water",
    text: "Track essential water parameters like pH, temperature, and salinity in real-time.",
    backgroundUrl: "assets/benefits/card-1.svg",
    iconUrl: faTv,
    imageUrl: benefitImage2,
  },
  {
    id: "1",
    title: "Easy API Documentation",
    text: "Integrate your own systems seamlessly with our easy-to-use API and detailed documentation.",
    backgroundUrl: "assets/benefits/card-2.svg",
    iconUrl: faCode,
    imageUrl: benefitImage2,
    light: true,
  },
  {
    id: "2",
    title: "Intuitive Data Visualization",
    text: "Visualize your water data with clear and customizable charts for quick insights.",
    backgroundUrl: "assets/benefits/card-3.svg",
    iconUrl: faChartLine,
    imageUrl: benefitImage2,
  },
  {
    id: "3",
    title: "Learn More About Water Parameters",
    text: "Discover why monitoring water parameters is crucial for maintaining aquatic health.",
    backgroundUrl: "assets/benefits/card-4.svg",
    iconUrl: faBookOpen,
    imageUrl: benefitImage2,
    light: true,
  },
  {
    id: "4",
    title: "AI-Powered Water Parameter Prediction (Coming Soon)",
    text: "Use AI to predict and forecast water parameter changes for proactive adjustments.",
    backgroundUrl: "assets/benefits/card-5.svg",
    iconUrl: faRobot,
    imageUrl: benefitImage2,
  },
  {
    id: "5",
    title: "See Local Public Lakes and Aquariums (Coming Soon)",
    text: "Explore water quality data from nearby lakes and public aquariums in your area.",
    backgroundUrl: "assets/benefits/card-6.svg",
    iconUrl: faWater,
    imageUrl: benefitImage2,
    light: true,
  },
];
