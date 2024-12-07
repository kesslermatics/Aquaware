import PropTypes from 'prop-types'; // Import for PropTypes validation
import SectionSvg from "../assets/svg/SectionSvg";

// Section component with customizable props for layout and children
const Section = ({
  className,
  id,
  crosses,
  crossesOffset,
  customPaddings,
  children,
}) => {
  return (
    <div
      id={id} // Assigns the ID to the section container
      className={`
        relative 
        ${
          customPaddings || 
          `py-10 lg:py-16 xl:py-20 ${crosses ? "lg:py-32 xl:py-40" : ""}`
        } 
        ${className || ""}
      `}
    >
      {/* Render child components inside the section */}
      {children}

      {/* Vertical lines on the left and right sides */}
      <div className="hidden absolute top-0 left-5 w-0.25 h-full bg-stroke-1 pointer-events-none md:block lg:left-7.5 xl:left-10" />
      <div className="hidden absolute top-0 right-5 w-0.25 h-full bg-stroke-1 pointer-events-none md:block lg:right-7.5 xl:right-10" />

      {/* Render crosses and SVG decorations if `crosses` is true */}
      {crosses && (
        <>
          <div
            className={`hidden absolute top-0 left-7.5 right-7.5 h-0.25 bg-stroke-1 ${
              crossesOffset && crossesOffset
            } pointer-events-none lg:block xl:left-10 right-10`}
          />
          <SectionSvg crossesOffset={crossesOffset} />
        </>
      )}
    </div>
  );
};

// Define PropTypes for the component to ensure proper usage
Section.propTypes = {
  className: PropTypes.string, // className should be a string (optional)
  id: PropTypes.string,        // id should be a string (optional)
  crosses: PropTypes.bool,     // crosses should be a boolean (optional)
  crossesOffset: PropTypes.string, // crossesOffset should be a string (optional)
  customPaddings: PropTypes.string, // customPaddings should be a string (optional)
  children: PropTypes.node.isRequired, // children are required and should be React nodes
};

// Default props for fallback values
Section.defaultProps = {
  className: '',      // Default to an empty string for className
  id: null,           // Default ID to null if not provided
  crosses: false,     // Default crosses to false
  crossesOffset: '',  // Default crossesOffset to an empty string
  customPaddings: '', // Default customPaddings to an empty string
};

export default Section;
