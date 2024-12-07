import PropTypes from 'prop-types'; // Import for PropTypes validation

// PlusSvg component to render a plus icon with customizable className
const PlusSvg = ({ className = "" }) => {
  return (
    <svg className={`${className}`} width="11" height="11" fill="none">
      {/* Path defining the plus shape */}
      <path
        d="M7 1a1 1 0 0 0-1-1H5a1 1 0 0 0-1 1v2a1 1 0 0 1-1 1H1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1h2a1 1 0 1 1-1 1v2a1 1 0 0 0 1 1h1a1 1 0 0 0 1-1V8a1 1 0 0 1 1-1h2a1 1 0 0 0 1-1V5a1 1 0 0 0-1-1H8a1 1 0 0 1-1-1V1z"
        fill="#ada8c4" // Fill color for the plus shape
      />
    </svg>
  );
};

// Define PropTypes for the component
PlusSvg.propTypes = {
  className: PropTypes.string, // className should be a string (optional)
};

export default PlusSvg;
