import Section from "./Section";
import Heading from "./Heading";
import { service1, service2, service3, check } from "../assets";
import { aquawareServices, aquawareServicesIcons } from "../constants";
import {
  PhotoChatMessage,
  Gradient,
  VideoBar,
  VideoChatMessage,
} from "./design/Services";

import Generating from "./Generating";

const Services = () => {
  return (
    <Section id="how-to-use">
      <div className="container">
        <Heading
          title="Getting Started with Aquaware"
          text="Monitor and manage your water data with ease using these simple steps."
        />

        <div className="relative">
          {/* First Tile: Steps to get started */}
          <div className="relative z-1 flex items-center h-[39rem] mb-5 p-8 border border-n-1/10 rounded-3xl overflow-hidden lg:p-20 xl:h-[46rem]">
            <div className="absolute top-0 left-0 w-full h-full flex items-center justify-center pointer-events-none md:w-3/5 xl:w-auto -translate-x-20">
              <img
                className="object-cover md:object-right"
                width={500}
                alt="Getting Started"
                height={330}
                src={service1}
              />
            </div>

            <div className="relative z-1 max-w-[50rem] ml-auto">
              <h4 className="h4 mb-4">Steps to Get Started</h4>
              <p className="body-2 mb-[3rem] text-n-3">
                Follow these simple steps to start monitoring your water:
              </p>
              <ul className="body-2">
                <li className="flex items-start py-4 border-t border-n-6">
                  <img width={24} height={24} src={check} />
                  <p className="ml-4">1. Create an account</p>
                </li>
                <li className="flex items-start py-4 border-t border-n-6">
                  <img width={24} height={24} src={check} />
                  <p className="ml-4">
                    2. Upload your water parameters via REST API
                  </p>
                </li>
                <li className="flex items-start py-4 border-t border-n-6">
                  <img width={24} height={24} src={check} />
                  <p className="ml-4">3. Set up automated monitoring alerts</p>
                </li>
                <li className="flex items-start py-4 border-t border-n-6">
                  <img width={24} height={24} src={check} />
                  <p className="ml-4">4. View historical data and trends</p>
                </li>
              </ul>
            </div>
          </div>

          {/* Second Tile: Data Visualization */}
          <div className="relative z-1 grid gap-5 lg:grid-cols-2">
            <div className="relative min-h-[39rem] border border-n-1/10 rounded-3xl overflow-hidden">
              <div className="absolute inset-0">
                <img
                  src={service2}
                  className="object-cover opacity-20"
                  width={630}
                  height={750}
                  alt="Data Visualization"
                />
              </div>

              <div className="absolute inset-0 flex flex-col justify-end p-8 bg-gradient-to-b from-n-8/0 to-n-8/90 lg:p-15">
                <h4 className="h4 mb-4">Visualize Your Data</h4>
                <p className="body-2 mb-[3rem] text-n-3">
                  Aquaware provides intuitive charts and graphs to help you
                  quickly understand your water data.
                </p>
              </div>
            </div>

            {/* Third Tile: Advanced Features */}
            <div className="p-4 bg-n-8 rounded-3xl overflow-hidden lg:min-h-[46rem] border border-n-1/10">
              <div className="py-12 px-4 xl:px-8">
                <h4 className="h4 mb-4">Advanced Features</h4>
                <p className="body-2 mb-[2rem] text-n-3">
                  Unlock advanced features like AI-driven predictions, custom
                  alerts, and public water data integration.
                </p>
              </div>

              <div className="relative h-[20rem] rounded-xl overflow-hidden md:h-[25rem]">
                <img
                  src={service3}
                  className="w-full h-full object-cover opacity-20"
                  width={520}
                  height={400}
                  alt="Advanced features"
                />

                <VideoChatMessage />
              </div>
            </div>
          </div>

          <Gradient />
        </div>
      </div>
    </Section>
  );
};

export default Services;
