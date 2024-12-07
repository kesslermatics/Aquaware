import PropTypes from 'prop-types'; // Import for PropTypes validation
import PlusSvg from "./PlusSvg"; // Import PlusSvg component

// SectionSvg component to render decorative plus icons with offset adjustments
const SectionSvg = ({ crossesOffset }) => {
  return (
    <>
      {/* Render left PlusSvg with optional crossesOffset */}
      <PlusSvg
        className={`hidden absolute -top-[0.3125rem] left-[1.5625rem] ${
          crossesOffset || "" // Apply crossesOffset if provided
        } pointer-events-none lg:block xl:left-[2.1875rem]`}
      />

      {/* Render right PlusSvg with optional crossesOffset */}
      <PlusSvg
        className={`hidden absolute -top-[0.3125rem] right-[1.5625rem] ${
          crossesOffset || "" // Apply crossesOffset if provided
        } pointer-events-none lg:block xl:right-[2.1875rem]`}
      />
    </>
  );
};

// Define PropTypes for the component
SectionSvg.propTypes = {
  crossesOffset: PropTypes.string, // crossesOffset should be a string (optional)
};

// Default props to handle missing optional values
SectionSvg.defaultProps = {
  crossesOffset: "", // Default crossesOffset to an empty string
};

export default SectionSvg;
