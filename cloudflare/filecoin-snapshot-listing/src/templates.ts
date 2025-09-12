// @ts-expect-error importing .txt files is not supported by TypeScript
import listingHtml from "templates/listing.html.txt";
// @ts-expect-error importing .txt files is not supported by TypeScript
import homeHtml from "templates/home.html.txt";
// @ts-expect-error importing .txt files is not supported by TypeScript
import cardHtml from "templates/card.html.txt";

export function renderListingPageTemplate(title: string, bodyContent: string): string {
  return listingHtml
    .replaceAll("{{title}}", title)
    .replace("{{bodyContent}}", bodyContent);
}

export function renderSnapshotCardTemplate(key: string, base: string, fileSize: string, uploaded: Date): string {
  return cardHtml
    .replaceAll("{{key}}", key)
    .replaceAll("{{base}}", base)
    .replaceAll("{{fileSize}}", fileSize)
    .replaceAll("{{uploaded}}", uploaded.toLocaleString("en-US", { timeZone: "UTC", hour12: false }))
}

export function renderSnapshotsHomePage(): string {
	return homeHtml;
}
