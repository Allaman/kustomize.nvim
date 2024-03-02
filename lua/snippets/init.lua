local M = {}
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

M.load_snippets = function()
  ls.add_snippets("yaml", {
    s("foo", {
      t("foobar"),
    }),
    s(
      "kust",
      fmta(
        [[
      ---
      apiVersion: kustomize.config.k8s.io/v1beta1
      kind: Kustomization
      namespace: foo
      labels:
        app.kubernetes.io/managed-by: kustomize
        app.kubernetes.io/name: foo
      commonAnnotations:
        foo: bar
      nameSuffix: foo
      resources:
        - foo.yaml
      <finish>
      ]],
        {
          finish = i(0),
        }
      )
    ),
    s(
      "kust_patch",
      fmta(
        [[
      patches:
        - target:
            group: <group>
            version: <version>
            kind: <kind>
            name: <name>
          patch: |-
            - op: <op>
              path: <path>
              value: <value>
      <finish>
      ]],
        {
          group = i(1, "group"),
          version = i(2, "version"),
          kind = i(3, "kind"),
          name = i(4, "name"),
          op = i(5, "operation"),
          path = i(6, "path"),
          value = i(7, "value"),
          finish = i(0),
        }
      )
    ),
    s(
      "kust_img",
      fmta(
        [[
      images:
        - name: <name>
          newName: <newName>
          newTag: <newTag>
      <finish>
      ]],
        {
          name = i(1, "name"),
          newName = i(2, "newName"),
          newTag = i(3, "newTag"),
          finish = i(0),
        }
      )
    ),
    s(
      "kust_cm",
      fmta(
        [[
      configMapGenerator:
        - name: <name>
          files:
            - <file>
          options:
            labels:
              - foo: bar
      <finish>
      ]],
        {
          name = i(1, "name"),
          file = i(2, "file"),
          finish = i(0),
        }
      )
    ),
  })
end

return M
