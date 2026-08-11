# Engineering Evidence Protocol

Use this protocol for engineering-practice research that combines official material, books, and talks. Keep the final guidance narrower than the evidence.

## Evidence classes

| Class | What it can establish | Main limit |
|---|---|---|
| Normative source | An obligation inside the source's declared scope, version, jurisdiction, and conformance model | It does not govern unrelated products or versions |
| Official product documentation | Supported behavior, lifecycle, defaults, compatibility, and vendor guidance for the documented version | Vendor guidance is not automatically a universal engineering norm |
| Original empirical research | Findings for the reported method, dataset, population, and date | Generalization requires matching conditions and often corroboration |
| Book | Bibliography, an author's synthesis, design vocabulary, and durable practices visible in accessed material | Metadata or a table of contents does not establish the full argument |
| Developer talk | Attributed practitioner experience, an official announcement, or an explained technique visible in accessed material | A title and platform metadata do not establish the talk's detailed claims |
| Secondary source | Discovery, interpretation, criticism, or independent corroboration | It should not replace an available governing or original source |

Label a statement `normative` only when the source itself imposes that obligation in the applicable scope. Label measured findings `empirical`. Label a practitioner's account `experience` and a value judgment or recommendation `opinion`. A synthesized rule is an inference unless a governing source states it for the exact target.

## Official documentation and standards

1. Identify the target version from local manifests, lockfiles, installed metadata, configuration, types, or the user's scope before choosing documentation.
2. Prefer a versioned specification or manual to a generic landing page. Record the document status such as draft, final, living, deprecated, withdrawn, or superseded.
3. Distinguish publication date from effective date, release date, event date, and access date. Record whichever dates affect applicability.
4. For a paid or partially accessible standard, use only the retrieved catalog entry, abstract, sample, or excerpt. Do not claim conformance or summarize inaccessible clauses.
5. Treat release notes, support policies, security advisories, and migration guides as separate evidence when lifecycle or compatibility matters.

## Books

1. Verify author or editor, exact title, edition, publication year, ISBN when present, and publisher or author URL. Check that ISBN, edition, and year describe the same record.
2. Record the deepest material actually accessed: `metadata`, `description_or_toc`, `excerpt`, or `full_text`. Do not promote one level to another.
3. Derive only topics visible at that depth. A publisher description or table of contents supports a cautious topical rule, not a claim that the complete reasoning, examples, or caveats were reviewed.
4. Treat version-specific commands, APIs, defaults, and security advice as historical until current official documentation confirms them.
5. Paraphrase. Quote only a short necessary passage within applicable copyright limits and attach the direct locator.

## Developer talks and playlists

1. Prefer the speaker's channel, the technology owner's engineering channel, or the official conference channel. Verify speaker or organization, exact title, publication date, event when stated, duration, and direct video or playlist URL.
2. Distinguish upload date from event date. Record both when the difference affects currency.
3. Platform metadata confirms identity and availability, not the content of the whole talk. Do not claim full viewing or transcription from metadata alone.
4. Support a detailed claim with an inspected timestamp, transcript segment, slides, code, or a corroborating primary document. Without that evidence, retain only a cautious topical principle and label it experience or opinion.
5. Cross-check announcements and version-sensitive advice against current official release documentation.

## Freshness and link checks

- Record an ISO `checked_at` date for every living source. Recheck current releases, support status, security guidance, and standards status close to use.
- Keep the direct canonical URL and observe redirects. Validate the final page's identity and scope. A successful response proves availability, not correctness or completeness.
- Treat `403`, authentication, paywalls, robot defenses, partial rendering, and missing transcripts as access limitations. Confirm identity through another authoritative surface when possible without claiming access to blocked content.
- Treat `404`, an empty search, or no match as inconclusive unless the searched source is known to be complete. Look for an official successor before marking a link dead.
- Never cite a search results page or snippet as support for a material claim.

## Conflicts

1. Confirm that sources address the same proposition. Apparent conflicts often use different versions, jurisdictions, workloads, threat models, or meanings.
2. Compare authority only after scope matches. An exact-version official contract governs product behavior. A final applicable standard outranks its obsolete edition or draft. Original data governs what a study measured. Books and talks can still expose trade-offs that official manuals omit.
3. Separate factual conflicts from competing recommendations. For recommendations, state the objective and constraints that make one option applicable rather than declaring a universal winner.
4. Preserve credible contrary evidence. If the conflict can change the answer and remains unresolved, report both positions, their evidence class, and the consequence.

## Source-to-rule records

For a catalog or synthesized rule set, retain these fields when available:

```text
source_id, source_type, author_or_organization, title, date_or_version,
url, checked_at, evidence_class, access_depth, scope, rule_ids, limitations
```

For every rule, retain a concise statement, applicable domains, direct supporting source IDs or locators, evidence class, strength, version or date scope, corroboration, contrary evidence, and inference status. Do not invent a missing field. Omit it or store an explicit unknown only when the requested schema requires one.

Use a curated index as a discovery and traceability aid, not as fresh proof. Reopen the primary URL and recheck changing metadata before using it for a current claim.

Stop researching when the evidence is applicable and sufficient for the consequence, material conflicts are resolved or exposed, and another bounded source is unlikely to change the result.
