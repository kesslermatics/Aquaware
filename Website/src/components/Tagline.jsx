import PropTypes from 'prop-types'; // Import for PropTypes validation
import brackets from "../assets/svg/Brackets";

// TagLine component to display text with decorative brackets
const TagLine = ({ className, children }) => {
  return (
    <div className={`tagline flex items-center ${className || ""}`}>
      {/* Render the left bracket */}
      {brackets("left")}
      
      {/* Render the children content */}
      <div className="mx-3 text-n-3">{children}</div>
      
      {/* Render the right bracket */}
      {brackets("right")}
    </div>
  );
};

// Define PropTypes for the component
TagLine.propTypes = {
  className: PropTypes.string,    // className should be a string (optional)
  children: PropTypes.node.isRequired, // children should be React nodes (required)
};

// Default props to handle missing optional values
TagLine.defaultProps = {
  className: '', // Default className to an empty string
};

export default TagLine;
