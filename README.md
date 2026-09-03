# KurTakip

TCMB verisiyle çalışan iOS döviz kuru uygulaması. SwiftUI ile geliştiriliyor.

## Durum

🚧 Geliştirme aşamasında. Şu an çalışan: kur listesi, TCMB bağlantısı, XML çözümleme.

## Yapı

- `RateService` — TCMB'den veriyi indirir, HTTP durumunu kontrol eder
- `RateParser` — gelen XML'i Rate nesnelerine çevirir
- `RatesCache` — kurları diske JSON olarak kaydeder ve okur
- `RatesViewModel` — ekran durumunu yönetir (veri, yükleniyor, hata)
- `ContentView` — sadece görüntüler

Ekran kodu verinin nereden geldiğini bilmiyor. ViewModel de XML diye bir
şeyin varlığından habersiz. Her katman yalnızca bir alt katmanı tanıyor.


## Karşılaştığım sorunlar

**Parser sessizce boş liste döndürüyordu.** Delege metodunun imzasında
`namespaceURI` parametresi eksikti. Swift bunu ayrı bir fonksiyon olarak
derliyor, XMLParser da tanımadığı için hiç çağırmıyordu. Derleme hatası
vermediği için `print` ile akışı adım adım izleyerek buldum.

**404 hatası sessizce boş ekrana dönüşüyordu.** URLSession yalnızca ağ
seviyesindeki hataları fırlatıyor; sunucunun 404 dönmesi başarılı bir istek
sayılıyor ve gelen HTML sayfası parser tarafından boş liste olarak
çözülüyordu. Sonuç: kullanıcı hiçbir açıklama olmadan bomboş bir ekran
görüyordu. HTTP durum kodunu ve çözümleme sonucunu ayrı ayrı kontrol
ederek her iki durumu da hata olarak ele aldım.

**Japon Yeni 100 birim üzerinden kote ediliyor.** TCMB `<Unit>100</Unit>`
gönderiyor. Bölme yapılmazsa yen 30 lira görünüyor, gerçek değeri 0,30.

**Bazı para birimlerinde fiyat boş geliyor.** XDR'nin `ForexSelling` alanı
boş. `Double("")` nil döndürdüğü için bu kayıtları listeye hiç eklemiyorum.


## Kararlar

**Cache-first veri akışı.** Uygulama açılışında önce diskteki son kayıtlı
kurlar gösteriliyor, ağ güncellemesi arkadan geliyor. Ağ hatası durumunda
elde veri varsa hata ekranı yerine küçük bir uyarı satırı çıkıyor —
eski veri, hiç veri olmamasından iyi.

**Neden JSON dosyası, neden SwiftData değil.** Veri küçük (20 kayıt,
iki alan) ve ilişkisel değil. SwiftData'nın kurulum maliyeti bu boyutta
bir veri için getirisinden fazlaydı. Codable ile JSON'a çevirip
Caches klasörüne yazmak yeterli oldu.

**Neden Caches klasörü.** iOS depolama azaldığında bu klasörü silebiliyor.
Kur verisi için doğru tercih, çünkü kaybolsa da yeniden indirilebilir.
Kullanıcının kendi verisi olsaydı Documents klasörü kullanılırdı.

## Sırada

- Detay ekranı ve grafik
