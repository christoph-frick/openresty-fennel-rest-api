(local cjson (require :cjson))
(local validation (require :resty.validation))

(fn log [msg]
  (ngx.log ngx.ERR msg))

(fn json [body status]
  (tset ngx.header :content-type "application/json")
  (tset ngx :status (or status ngx.HTTP_OK))
  (ngx.say (cjson.encode body)))

(fn validate
  [validation on-success]
  (let [body (cjson.decode (ngx.req.get_body_data))]
    (match (validation body)
      (true fields _) (on-success fields)
      (false _ errors) (json {:validation-errors errors} 
                             ngx.HTTP_BAD_REQUEST))))

(local helloworld-validation
  (let [name (-> validation.string
                 (: :minlen 1))]
    (validation.new {:name name})))

(fn helloworld-handler
  [fields]
  (json {:hello (. fields :name :value)}))

{:run (fn run []
        (if true ; routing here
          (validate 
            helloworld-validation 
            helloworld-handler)
          (json {:not-found ngx.var.uri} 
                ngx.HTTP_NOT_FOUND)))}
