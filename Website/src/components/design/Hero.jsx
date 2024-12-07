import PropTypes from 'prop-types'; // Import for PropTypes validation
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

// BackgroundCircles component with moving icons and parallax effect
export const BackgroundCircles = ({ parallaxRef }) => {
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    // Mark the component as mounted to trigger animations
    setMounted(true);
  }, []);

  return (
    <div className="absolute -top-[42.375rem] left-1/2 w-[78rem] aspect-square border border-n-2/5 rounded-full -translate-x-1/2 md:-top-[38.5rem] xl:-top-[32rem]">
      {/* Static rings */}
      <Rings />

      {/* Moving background elements with parallax effect */}
      <MouseParallax strength={0.07} parallaxContainerRef={parallaxRef}>
        {/* Example of floating icons */}
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

        {/* Additional icons with different rotations */}
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

// Define PropTypes for BackgroundCircles
BackgroundCircles.propTypes = {
  parallaxRef: PropTypes.object, // parallaxRef should be an object (optional)
};

// Default props for BackgroundCircles
BackgroundCircles.defaultProps = {
  parallaxRef: null, // Default to null if no ref is provided
};
