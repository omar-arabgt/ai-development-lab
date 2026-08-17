// Sentry -> GitHub relay (Cloudflare Worker, free tier)
// Receives Sentry issue-alert webhooks and triggers the Bug Fix Agent
// workflow in the right repo via repository_dispatch.
//
// Worker secrets to set (Worker -> Settings -> Variables):
//   GITHUB_TOKEN : fine-grained PAT, repos ArabGT-Mobile + arabgt-backend,
//                  permission "Contents: Read and write" (enables dispatches)
//   RELAY_KEY    : any long random string; must match the ?key= in the URL
//                  you give Sentry (rejects strangers hitting the URL)

export default {
  async fetch(request, env) {
    if (request.method !== "POST") return new Response("ok");
    const url = new URL(request.url);
    if (url.searchParams.get("key") !== env.RELAY_KEY)
      return new Response("forbidden", { status: 403 });

    const payload = await request.json().catch(() => null);
    const issue =
      payload?.data?.issue || payload?.data?.event?.issue || payload?.data?.event || {};
    const shortId = issue.shortId || issue.short_id || "";
    const project = issue.project?.slug || issue.project_slug || "";
    if (!shortId) return new Response("no issue id — ignored");

    const repo = project.startsWith("backend") ? "arabgt-backend" : "ArabGT-Mobile";
    const r = await fetch(
      `https://api.github.com/repos/ArabGT-Platform/${repo}/dispatches`,
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${env.GITHUB_TOKEN}`,
          Accept: "application/vnd.github+json",
          "User-Agent": "arabgt-sentry-relay",
        },
        body: JSON.stringify({
          event_type: "sentry_issue",
          client_payload: { short_id: shortId, project },
        }),
      }
    );
    return new Response(`dispatched ${shortId} -> ${repo}: ${r.status}`);
  },
};
