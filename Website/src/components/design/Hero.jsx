import { useEffect, useState } from "react";
import { MouseParallax } from "react-just-parallax";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faFish,
  faFishFins,
  faOtter,
  faClover,
  faShrimp,
} from "@fortawesome/free-solid-svg-icons";

import PlusSvg from "../../assets/svg/PlusSvg";

export const Gradient = () => {
  return (
    <>
      <div className="relative z-1 h-6 mx-2.5 bg-n-11 shadow-xl rounded-b-[1.25rem] lg:h-6 lg:mx-8" />
      <div className="relative z-1 h-6 mx-6 bg-n-11/70 shadow-xl rounded-b-[1.25rem] lg:h-6 lg:mx-20" />
    </>
  );
};

export const BottomLine = () => {
  return (
    <>
      <div className="hidden absolute top-[55.25rem] left-10 right-10 h-0.25 bg-n-6 pointer-events-none xl:block" />

      <PlusSvg className="hidden absolute top-[54.9375rem] left-[2.1875rem] z-2 pointer-events-none xl:block" />

      <PlusSvg className="hidden absolute top-[54.9375rem] right-[2.1875rem] z-2 pointer-events-none xl:block" />
    </>
  );
};

const Rings = () => {
  return (
    <>
      <div className="absolute top-1/2 left-1/2 w-[65.875rem] aspect-square border border-n-2/10 rounded-full -translate-x-1/2 -translate-y-1/2" />
      <div className="absolute top-1/2 left-1/2 w-[51.375rem] aspect-square border border-n-2/10 rounded-full -translate-x-1/2 -translate-y-1/2" />
      <div className="absolute top-1/2 left-1/2 w-[36.125rem] aspect-square border border-n-2/10 rounded-full -translate-x-1/2 -translate-y-1/2" />
      <div className="absolute top-1/2 left-1/2 w-[23.125rem] aspect-square border border-n-2/10 rounded-full -translate-x-1/2 -translate-y-1/2" />
    </>
  );
};

export const BackgroundCircles = ({ parallaxRef }) => {
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  return (
    <div className="absolute -top-[42.375rem] left-1/2 w-[78rem] aspect-square border border-n-2/5 rounded-full -translate-x-1/2 md:-top-[38.5rem] xl:-top-[32rem]">
      <Rings />

      {/* Moving background colored circle balls */}
      <MouseParallax strength={0.07} parallaxContainerRef={parallaxRef}>
        <div className="absolute bottom-1/2 left-1/2 w-0.25 h-1/2 origin-bottom rotate-[46deg]">
          <FontAwesomeIcon
            icon={faFish}
            size="3x"
            className={`-ml-1 -mt-36 text-[#DD734F] transition-transform duration-500 ease-out ${
              mounted
                ? "translate-y-0 opacity-[.4]"
                : "translate-y-10 opacity-[.03]"
            }`}
          />
        </div>

        <div className="absolute bottom-1/2 left-1/2 w-0.25 h-1/2 origin-bottom -rotate-[56deg]">
          <FontAwesomeIcon
            icon={faFishFins}
            size="4x"
            className={`-ml-1 -mt-32 text-[#FF776F] transition-transform duration-500 ease-out ${
              mounted
                ? "translate-y-0 opacity-[.4]"
                : "translate-y-10 opacity-0"
            }`}
          />
        </div>

        <div className="absolute bottom-1/2 left-1/2 w-0.25 h-1/2 origin-bottom rotate-[54deg]">
          <FontAwesomeIcon
            icon={faFish}
            size="3x"
            className={`hidden mt-[12.9rem] xl:block text-[#B9AEDF] transition-transform duration-500 ease-out ${
              mounted
                ? "translate-y-0 opacity-[.4]"
                : "translate-y-10 opacity-0"
            }`}
          />
        </div>

        <div className="absolute bottom-1/2 left-1/2 w-0.25 h-1/2 origin-bottom -rotate-[65deg]">
          <FontAwesomeIcon
            icon={faOtter}
            size="3x"
            className={`-ml-1.5 mt-52 text-[#88E5BE] transition-transform duration-500 ease-out ${
              mounted
                ? "translate-y-0 opacity-[.4]"
                : "translate-y-10 opacity-0"
            }`}
          />
        </div>

        <div className="absolute bottom-1/2 left-1/2 w-0.25 h-1/2 origin-bottom -rotate-[85deg]">
          <FontAwesomeIcon
            icon={faClover}
            size="4x"
            className={`-ml-3 -mt-3 text-[#B9AEDF] transition-transform duration-500 ease-out ${
              mounted
                ? "translate-y-0 opacity-[.4]"
                : "translate-y-10 opacity-0"
            }`}
          />
        </div>

        <div className="absolute bottom-1/2 left-1/2 w-0.25 h-1/2 origin-bottom rotate-[70deg]">
          <FontAwesomeIcon
            icon={faShrimp}
            size="4x"
            className={`-ml-3 -mt-3 text-[#88E5BE] transition-transform duration-500 ease-out ${
              mounted
                ? "translate-y-0 opacity-[.4]"
                : "translate-y-10 opacity-0"
            }`}
          />
        </div>
      </MouseParallax>
    </div>
  );
};
