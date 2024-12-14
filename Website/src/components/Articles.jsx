import React, { useState } from "react";
import { Link } from "react-router-dom";
import { useTranslation } from "react-i18next";
import Section from "./Section";

const Articles = () => {
  const { t } = useTranslation();
  const [searchTerm, setSearchTerm] = useState("");
  const [selectedCategory, setSelectedCategory] = useState("all");

  // Hole Artikeldaten aus der `translation.json`
  const articles = t("blog.articles", { returnObjects: true });
  const articleList = Object.keys(articles).map((key) => ({
    slug: key,
    ...articles[key],
  }));

  // Filter und Suchlogik
  const filteredArticles = articleList.filter((article) => {
    const matchesSearch =
      article.title &&
      article.title.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory =
      selectedCategory === "all" || article.category === selectedCategory;

    return matchesSearch && matchesCategory;
  });

  return (
    <Section>
      <div className="container mx-auto p-4">
        <h1 className="text-4xl font-bold text-center mb-10">
          {t("blog.guides_title", "Articles & Guides")}
        </h1>

        {/* Suchfeld und Filter */}
        <div className="mb-6 space-y-4">
          {/* Suchfeld */}
          <input
            type="text"
            placeholder={t("blog.search_placeholder", "Search articles...")}
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full p-2 border border-gray-300 rounded bg-n-6 text-white"
          />

          {/* Kategorie-Filter */}
          <select
            value={selectedCategory}
            onChange={(e) => setSelectedCategory(e.target.value)}
            className="p-2 border border-gray-300 rounded bg-n-6 text-white"
            style={{ width: "auto", minWidth: "150px" }}
          >
            <option value="all">
              {t("blog.filter.all", "All Categories")}
            </option>
            {[...new Set(articleList.map((article) => article.category))].map(
              (category) => (
                <option key={category} value={category}>
                  {category}
                </option>
              )
            )}
          </select>
        </div>

        {/* Artikelkarten */}
        <div className="space-y-4 ">
          {filteredArticles.map((article) => (
            <Link
              to={`/articles/${article.category.toLowerCase()}/${article.slug}`}
              key={article.slug}
              className="block"
            >
              <div className="bg-gray-800 text-white shadow-lg rounded-lg p-6 hover:shadow-xl transition-shadow duration-300 flex items-center justify-between">
                <div>
                  <h2 className="text-xl font-semibold">{article.title}</h2>
                  {/* Kategorie-Tag */}
                  <div className="inline-block bg-n-6 text-sm text-gray-300 py-1 px-3 rounded-full mt-2">
                    {article.category}
                  </div>
                  <p className="text-sm text-gray-400 mt-1">
                    {t("blog.date", "Published on")}:{" "}
                    {new Date(article.date).toLocaleDateString(undefined, {
                      year: "numeric",
                      month: "long",
                      day: "numeric",
                    })}
                  </p>
                </div>
                <div className="text-gray-400 ml-4">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                    strokeWidth={2}
                    stroke="currentColor"
                    className="w-6 h-6 opacity-70"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      d="M9 5l7 7-7 7"
                    />
                  </svg>
                </div>
              </div>
            </Link>
          ))}
          {filteredArticles.length === 0 && (
            <p className="text-center text-gray-400">
              {t("blog.no_results", "No articles found.")}
            </p>
          )}
        </div>
      </div>
    </Section>
  );
};

export default Articles;
