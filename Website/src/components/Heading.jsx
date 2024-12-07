import PropTypes from 'prop-types'; // Import for PropTypes
import TagLine from './Tagline';

// Heading component with props validation using PropTypes
const Heading = ({ className, title, text, tag }) => {
  return (
    <div
      className={`${className} max-w-[50rem] mx-auto mb-12 lg:mb-20 md:text-center`}
    >
      {/* Render TagLine component if tag prop exists */}
      {tag && <TagLine className="mb-4 md:justify-center">{tag}</TagLine>}
      
      {/* Render title if it exists */}
      {title && <h2 className="h2">{title}</h2>}
      
      {/* Render text if it exists */}
      {text && <p className="body-2 mt-4 text-n-4">{text}</p>}
    </div>
  );
};

// Define PropTypes to validate props
Heading.propTypes = {
  className: PropTypes.string, // className should be a string
  title: PropTypes.string,     // title should be a string
  text: PropTypes.string,      // text should be a string
  tag: PropTypes.node,         // tag can be a React node (e.g., text or JSX element)
};

// Define default props to avoid undefined values
Heading.defaultProps = {
  className: '', // Default className is an empty string
  title: '',     // Default title is an empty string
  text: '',      // Default text is an empty string
  tag: null,     // Default tag is null
};

export default Heading;
