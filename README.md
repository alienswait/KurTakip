# KurTakip

TCMB verisiyle çalışan iOS döviz kuru uygulaması. SwiftUI ile geliştiriliyor.

## Durum

🚧 Geliştirme aşamasında. Şu an çalışan: kur listesi, TCMB bağlantısı, XML çözümleme.

## Yapı

- `RateService` — TCMB'den veriyi indirir
- `RateParser` — gelen XML'i Rate nesnelerine çevirir
- `ContentView` — listeyi gösterir

Ekran kodu verinin nereden geldiğini bilmiyor. Bu ayrım sayesinde ileride
veri kaynağı değişse ekran tarafında değişiklik gerekmeyecek.

## Karşılaştığım sorunlar

**Parser sessizce boş liste döndürüyordu.** Delege metodunun imzasında
`namespaceURI` parametresi eksikti. Swift bunu ayrı bir fonksiyon olarak
derliyor, XMLParser da tanımadığı için hiç çağırmıyordu. Derleme hatası
vermediği için `print` ile akışı adım adım izleyerek buldum.

**Japon Yeni 100 birim üzerinden kote ediliyor.** TCMB `<Unit>100</Unit>`
gönderiyor. Bölme yapılmazsa yen 30 lira görünüyor, gerçek değeri 0,30.

**Bazı para birimlerinde fiyat boş geliyor.** XDR'nin `ForexSelling` alanı
boş. `Double("")` nil döndürdüğü için bu kayıtları listeye hiç eklemiyorum.

## Sırada

- ViewModel'e taşıma
- Çevrimdışı erişim
- Detay ekranı ve grafik
