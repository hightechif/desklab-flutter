package edts.taurus.desklab

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform