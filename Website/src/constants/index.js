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

export const heroIcons = [homeSmile, file02, searchMd, plusSquare];

export const companyLogos = [yourlogo, yourlogo, yourlogo, yourlogo, yourlogo];

export const pricing = [
  {
    id: "1",
    title: "Hobby",
    description:
      "Free for personal use, monitor all water parameters with limited uploads",
    price: "0",
    features: [
      "Monitor all water parameters (e.g., pH, temperature, salinity, etc.)",
      "Upload water values every 2 hours to conserve resources",
      "Basic water quality tracking",
      "Access to real-time data visualization",
    ],
    buttonText: "Get started for Free",
    buttonRef: "/signup",
  },
  {
    id: "2",
    title: "Advanced",
    description: "Advanced monitoring tools for precise water tracking",
    price: "2.99",
    features: [
      "Everything from the Hobby plan",
      "Upload water values every 30 minutes for precise tracking",
      "Add alerts and notifications for specific water parameter thresholds",
    ],
    buttonText: "Leverage your tracking",
    buttonRef: "/dashboard#pricingplans",
  },
  {
    id: "3",
    title: "Premium",
    description:
      "Frequent water monitoring with AI tools for detailed insights and more",
    price: "6.99",
    features: [
      "Everything from the Hobby and Advanced plan",
      "Add public water bodies for public data sharing",
      "Priority customer support",
      "Perfect for individuals needing detailed water insights with high accuracy",
      "AI tools included (coming soon)",
    ],
    buttonText: "Upgrade to premium features",
    buttonRef: "/dashboard#pricingplans",
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
