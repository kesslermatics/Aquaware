import React from 'react';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <title>Aquaware</title>
        <div className="hero">
          <h1>Welcome to Aquaware</h1>
          <p>Your all-in-one solution for managing your aquatic environments.</p>
          <a href="#features" className="cta">Explore Features</a>
        </div>
      </header>

      <section id="features">
        <h2>Key Features</h2>
        <div className="features-grid">
          <div className="feature">
            <h3>Real-Time Monitoring</h3>
            <p>Monitor water quality in real-time for parameters like temperature, pH, and TDS.</p>
          </div>
          <div className="feature">
            <h3>Data Analytics</h3>
            <p>Track trends and visualize data to keep your aquatic environment optimized.</p>
          </div>
          <div className="feature">
            <h3>Custom Alerts</h3>
            <p>Get notified instantly when your water conditions are outside the optimal range.</p>
          </div>
          <div className="feature">
            <h3>AI Predictions</h3>
            <p>Leverage AI for predictive insights and recommendations on water quality.</p>
          </div>
        </div>
      </section>

      <section id="pricing">
        <h2>Pricing</h2>
        <div className="pricing-plans">
          <div className="plan">
            <h3>Free</h3>
            <p>Access basic features for free.</p>
            <p><strong>$0/month</strong></p>
            <ul>
              <li>Water quality tracking</li>
              <li>Basic data analytics</li>
            </ul>
          </div>
          <div className="plan">
            <h3>Premium</h3>
            <p>Unlock advanced features with our premium plan.</p>
            <p><strong>$9.99/month</strong></p>
            <ul>
              <li>Advanced analytics</li>
              <li>AI-powered predictions</li>
              <li>Custom alert settings</li>
            </ul>
          </div>
        </div>
      </section>

      <section id="support">
        <h2>Support & Community</h2>
        <p>Need help? Join our community of users or reach out to our support team!</p>
        <a href="#contact" className="cta">Get Support</a>
      </section>

      <footer>
        <p>&copy; 2024 Aquaware. All rights reserved.</p>
      </footer>
    </div>
  );
}

export default App;
