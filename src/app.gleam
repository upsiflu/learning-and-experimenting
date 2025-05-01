import gleam/dynamic/decode
import gleam/int
import gleam/list
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import rsvp

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

type Model {
  Model(total: Int, cats: List(CatOrPidgeon))
}

type CatOrPidgeon {
  Cat(id: String, url: String)
}

fn init(_args) -> #(Model, Effect(Msg)) {
  let model = Model(total: 0, cats: [])

  #(model, effect.none())
}

type Msg {
  UserClickedAddCat
  UserClickedRemoveCat
  ApiReturnedCats(Result(List(CatOrPidgeon), rsvp.Error))
}

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    UserClickedAddCat -> #(Model(..model, total: model.total + 1), get_cat())

    UserClickedRemoveCat -> #(
      Model(total: model.total - 1, cats: model.cats |> list.drop(1)),
      effect.none(),
    )

    ApiReturnedCats(Ok(cats)) -> #(
      Model(..model, cats: list.append(model.cats, cats)),
      effect.none(),
    )

    ApiReturnedCats(Error(_)) -> #(model, effect.none())
  }
}

fn get_cat() -> Effect(Msg) {
  let decoder = {
    use id <- decode.field("id", decode.string)
    use url <- decode.field("url", decode.string)

    decode.success(Cat(id:, url:))
  }
  let url = "https://api.thecatapi.com/v1/images/search"
  let handler = rsvp.expect_json(decode.list(decoder), ApiReturnedCats)

  rsvp.get(url, handler)
}

fn view(model: Model) -> Element(Msg) {
  html.div([], [
    html.div([], [
      html.button([event.on_click(UserClickedAddCat)], [html.text("Add cat")]),
      html.p([], [html.text(int.to_string(model.total))]),
      html.button(
        [
          event.on_click(UserClickedRemoveCat),
          attribute.disabled(model.total < 1),
        ],
        [html.text("Remove cat")],
      ),
    ]),
    html.div([], { list.map(model.cats, view_cat) }),
  ])
}

fn view_cat(cat: CatOrPidgeon) {
  html.img([attribute.src(cat.url), attribute.width(400)])
}
