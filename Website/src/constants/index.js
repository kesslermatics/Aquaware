import { faTv } from "@fortawesome/free-solid-svg-icons";
import { faCode } from "@fortawesome/free-solid-svg-icons";
import { faChartLine } from "@fortawesome/free-solid-svg-icons";
import { faRobot } from "@fortawesome/free-solid-svg-icons";
import { faWater } from "@fortawesome/free-solid-svg-icons";
import { faBookOpen } from "@fortawesome/free-solid-svg-icons";

import {
  benefitImage2,
  chromecast,
  disc02,
  discord,
  discordBlack,
  facebook,
  figma,
  file02,
  framer,
  homeSmile,
  instagram,
  notion,
  photoshop,
  plusSquare,
  protopie,
  raindrop,
  recording01,
  recording03,
  roadmap1,
  roadmap2,
  roadmap3,
  roadmap4,
  searchMd,
  slack,
  sliders04,
  telegram,
  twitter,
  yourlogo,
} from "../../src/assets";

export const navigation = [
  {
    id: "0",
    title: "Features",
    url: "#features",
  },
  {
    id: "1",
    title: "How it works",
    url: "#how-to-use",
  },
  {
    id: "2",
    title: "Pricing",
    url: "#pricing",
  },
  {
    id: "3",
    title: "Roadmap",
    url: "#roadmap",
  },
  {
    id: "4",
    title: "Create Account",
    url: "#signup",
    onlyMobile: true,
  },
  {
    id: "5",
    title: "Login",
    url: "#login",
    onlyMobile: true,
  },
];

export const heroIcons = [homeSmile, file02, searchMd, plusSquare];

export const companyLogos = [yourlogo, yourlogo, yourlogo, yourlogo, yourlogo];

export const aquawareServices = [
  "Water Value Monitoring",
  "AI-Powered Insights",
  "Seamless Data Visualization",
];

export const aquawareServicesIcons = [
  recording03,
  recording01,
  disc02,
  chromecast,
  sliders04,
];

export const roadmap = [
  {
    id: "0",
    title: "Water Quality Monitoring",
    text: "Enable users to monitor real-time water quality values such as pH, temperature, and salinity for their aquariums or natural bodies of water.",
    date: "July 2023",
    status: "done",
    imageUrl: roadmap1,
    colorful: true,
  },
  {
    id: "1",
    title: "AI-Powered Analysis",
    text: "Introduce AI-driven insights to predict water quality trends and suggest improvements.",
    date: "August 2023",
    status: "progress",
    imageUrl: roadmap2,
  },
  {
    id: "2",
    title: "Public Water Data Access",
    text: "Allow users to view water quality data from nearby public lakes and reservoirs, increasing community awareness and engagement.",
    date: "October 2023",
    status: "progress",
    imageUrl: roadmap3,
  },
  {
    id: "3",
    title: "Advanced Data Visualization",
    text: "Offer advanced charts and visual tools for users to track and compare historical water data.",
    date: "November 2023",
    status: "planned",
    imageUrl: roadmap4,
  },
];

export const collabText =
  "Aquaware provides seamless water monitoring with real-time data, ensuring your aquariums and natural water bodies remain healthy and balanced.";

export const collabContent = [
  {
    id: "0",
    title: "Real-Time Monitoring",
    text: collabText,
  },
  {
    id: "1",
    title: "AI-Powered Insights",
  },
  {
    id: "2",
    title: "Advanced Data Visualization",
  },
];

export const collabApps = [
  {
    id: "0",
    title: "Figma",
    icon: figma,
    width: 26,
    height: 36,
  },
  {
    id: "1",
    title: "Notion",
    icon: notion,
    width: 34,
    height: 36,
  },
  {
    id: "2",
    title: "Discord",
    icon: discord,
    width: 36,
    height: 28,
  },
  {
    id: "3",
    title: "Slack",
    icon: slack,
    width: 34,
    height: 35,
  },
  {
    id: "4",
    title: "Photoshop",
    icon: photoshop,
    width: 34,
    height: 34,
  },
  {
    id: "5",
    title: "Protopie",
    icon: protopie,
    width: 34,
    height: 34,
  },
  {
    id: "6",
    title: "Framer",
    icon: framer,
    width: 26,
    height: 34,
  },
  {
    id: "7",
    title: "Raindrop",
    icon: raindrop,
    width: 38,
    height: 32,
  },
];

export const pricing = [
  {
    id: "0",
    title: "Basic",
    description: "Monitor 1 water value, free for personal use",
    price: "0",
    features: [
      "Monitor one water parameter (e.g., pH or temperature)",
      "Basic water quality tracking",
      "Access to real-time data visualization",
    ],
  },
  {
    id: "1",
    title: "Advanced",
    description:
      "Monitor multiple water values, AI insights, advanced visualizations",
    price: "9.99",
    features: [
      "Monitor multiple water parameters",
      "AI-powered insights for trend analysis",
      "Advanced visual tools for data tracking",
    ],
  },
  {
    id: "2",
    title: "Enterprise",
    description:
      "Custom monitoring solutions for large aquariums or public water bodies",
    price: null,
    features: [
      "Custom water quality monitoring",
      "Dedicated support and tailored features",
      "Historical data access and AI insights",
    ],
  },
];

export const benefits = [
  {
    id: "0",
    title: "Monitor Your Water",
    text: "Track essential water parameters like pH, temperature, and salinity in real-time.",
    backgroundUrl: "./src/assets/benefits/card-1.svg",
    iconUrl: faTv,
    imageUrl: benefitImage2,
  },
  {
    id: "1",
    title: "Easy API Documentation",
    text: "Integrate your own systems seamlessly with our easy-to-use API and detailed documentation.",
    backgroundUrl: "./src/assets/benefits/card-2.svg",
    iconUrl: faCode,
    imageUrl: benefitImage2,
    light: true,
  },
  {
    id: "2",
    title: "Intuitive Data Visualization",
    text: "Visualize your water data with clear and customizable charts for quick insights.",
    backgroundUrl: "./src/assets/benefits/card-3.svg",
    iconUrl: faChartLine,
    imageUrl: benefitImage2,
  },
  {
    id: "3",
    title: "Learn More About Water Parameters",
    text: "Discover why monitoring water parameters is crucial for maintaining aquatic health.",
    backgroundUrl: "./src/assets/benefits/card-6.svg",
    iconUrl: faBookOpen,
    imageUrl: benefitImage2,
    light: true,
  },
  {
    id: "4",
    title: "AI-Powered Water Parameter Prediction (Coming Soon)",
    text: "Use AI to predict and forecast water parameter changes for proactive adjustments.",
    backgroundUrl: "./src/assets/benefits/card-4.svg",
    iconUrl: faRobot,
    imageUrl: benefitImage2,
    light: true,
  },
  {
    id: "5",
    title: "See Local Public Lakes and Aquariums (Coming Soon)",
    text: "Explore water quality data from nearby lakes and public aquariums in your area.",
    backgroundUrl: "./src/assets/benefits/card-5.svg",
    iconUrl: faWater,
    imageUrl: benefitImage2,
  },
];

export const socials = [
  {
    id: "0",
    title: "Discord",
    iconUrl: discordBlack,
    url: "#",
  },
  {
    id: "1",
    title: "Twitter",
    iconUrl: twitter,
    url: "#",
  },
  {
    id: "2",
    title: "Instagram",
    iconUrl: instagram,
    url: "#",
  },
  {
    id: "3",
    title: "Telegram",
    iconUrl: telegram,
    url: "#",
  },
  {
    id: "4",
    title: "Facebook",
    iconUrl: facebook,
    url: "#",
  },
];
