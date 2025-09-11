// @ts-ignore
import listingHtml from "templates/listing.html.txt";
// @ts-ignore
import homeHtml from "templates/home.html.txt";
// @ts-ignore
import cardHtml from "templates/card.html.txt";

export function renderListingPageTemplate(title: string, bodyContent: string): string {
  return listingHtml
    .replaceAll("{{title}}", title)
    .replace("{{bodyContent}}", bodyContent);
}

export function renderSnapshotCardTemplate(key: string, base: string, fileSize: string, uploaded: Date, snap_type: string): string {
  return cardHtml
    .replaceAll("{{key}}", key)
    .replaceAll("{{base}}", base)
    .replaceAll("{{fileSize}}", fileSize)
    .replaceAll("{{uploaded}}", uploaded.toLocaleString("en-US", { timeZone: "UTC", hour12: false }))
    .replaceAll("{{shaButtonUrl}}", snap_type == "v2" ? base : base.replace(".zst", ""))
    .replaceAll("{{metaButtonHide}}", snap_type === "v2" ? "" : "hidden")
}

export function renderSnapshotsHomePage(): string {
	return homeHtml;
}
