import clsx from "clsx";
import styles from "./index.module.css";
import React from "react";

function LanguageSelection() {
  return (
    <header className={clsx("", styles.heroBanner)}>
      <div className={clsx(styles.languageSelection, "container")}> 
        <h1 className="hero__title" style={{ fontSize: "2.5rem" }}>Welcome to Aquaware</h1>
        <p className="hero__subtitle" style={{ fontSize: "1.5rem" }}>Select your preferred language</p>
        <div className={styles.buttons} style={{ display: "flex", alignItems: "center", gap: "20px" }}>
          <a
            className="button button--secondary button--lg"
            href="https://docs.aquaware.cloud/docs/getting-started/welcome"
            style={{ display: "flex", alignItems: "center", fontSize: "1.25rem", padding: "15px 25px" }}
          >
            <img src="https://upload.wikimedia.org/wikipedia/en/a/ae/Flag_of_the_United_Kingdom.svg" alt="English" style={{ width: 32, height: 22, marginRight: 15, verticalAlign: "middle" }} />
            English
          </a>
          <a
            className="button button--secondary button--lg"
            href="https://docs.aquaware.cloud/de/docs/getting-started/welcome"
            style={{ display: "flex", alignItems: "center", fontSize: "1.25rem", padding: "15px 25px" }}
          >
            <img src="https://upload.wikimedia.org/wikipedia/en/b/ba/Flag_of_Germany.svg" alt="Deutsch" style={{ width: 32, height: 22, marginRight: 15, verticalAlign: "middle" }} />
            Deutsch
          </a>
        </div>
      </div>
    </header>
  );
}

export default function Home() {
  return <LanguageSelection />;
}