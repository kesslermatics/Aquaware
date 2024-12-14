import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { useTranslation } from "react-i18next";
import ReactMarkdown from "react-markdown";
import Section from "./Section";

// Dynamischer Import der Markdown-Dateien
const markdownFiles = import.meta.glob("../data/articles/**/*.md", {
  eager: true,
});

function BlogPost() {
  const { category, slug } = useParams();
  const { t, i18n } = useTranslation();
  const [content, setContent] = useState("");

  useEffect(() => {
    const language = i18n.language || "en";
    const filePath = `../data/articles/${language}/${slug}.md`;

    const markdownFile = markdownFiles[filePath];
    if (markdownFile) {
      setContent(markdownFile.default || markdownFile);
    } else {
      setContent(`# ${t("blog.article_not_found", "Article not found")}`);
    }
  }, [slug, i18n.language, t]);

  const articles = t("blog.articles", { returnObjects: true });
  const article = Object.values(articles).find((a) => a.slug === slug);

  if (!article) {
    return (
      <div className="text-center text-xl">
        {t("blog.article_not_found", "Article not found")}
      </div>
    );
  }

  const formattedDate = new Date(article.date).toLocaleDateString(undefined, {
    year: "numeric",
    month: "long",
    day: "numeric",
  });

  const wordCount = content.split(/\s+/).length;
  const readingTime = Math.ceil(wordCount / 200);

  return (
    <Section>
      <article className="prose max-w-5xl mx-auto p-4">
        <div className="flex justify-between text-sm text-n-4 mb-6 p-4">
          <span>{formattedDate}</span>
          <span>
            {readingTime} {t("blog.reading_time", "min read")}
          </span>
        </div>
        <ReactMarkdown
          class="prose lg:prose-xl "
          className="mx-auto p-4 prose-headings:text-n-1 prose-strong:text-n-1 text-n-2 prose-headings:font-bold"
        >
          {content}
        </ReactMarkdown>
      </article>
    </Section>
  );
}

export default BlogPost;
