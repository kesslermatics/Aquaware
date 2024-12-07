import Head from 'next/head';

const NotFoundPage = () => {
  return (
    <>
      <Head>
        <title>404 - Page not found</title>
        <meta name="description" content="The page you are looking for does not exist." />
      </Head>
      <div className="text-center">
        <h1>404 - Page not found</h1>
        <p>Sorry, this page does not exist.</p>
      </div>
    </>
  );
};

export default NotFoundPage;
